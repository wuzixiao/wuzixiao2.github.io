	Twitter's realtime search engine was rewrote in 2010 based on Lucene and get rid of MySQL to fit with large currency, high performance requirement.
	There are 4 requirements in this search engine:
	1. Low-latency, high-throughput query evaluation.
	2. High ingestion rate and immediate data availabitity.
	3. Concurrent reads and writes.
	4. Dominance of the temporal signal.

	Architecture of this real-time search service.
	/img/

	Ingestion is similar with spider in the normal search engine, and Earlybird is index component. Blender is a service between user and search engine. It takes responsibility of parse user's query and sort the results from each Earlybird to give best result to each user.

	Two core tech parts:
	1. Reverse index organization
	{term | {docid,termposition}, {docid, termpositon}...}. For each term, there are a list of postings to response with. It is the essitial of reverse index. In Earlybird, docid is just 24bit because twitter limit each index block to contain 2**23 posts. and termpostion is 8bit because each twitter  only contains 140 chars. In index block, the organization of memory is shown below:
	/pic/
	Each new term start to fill in the 2**1 slice pool then fill to 2**4 pool's slice, at last 2**11 pool's slice. No need to memory copy in this method.
	At any moment, there are only one index block to write and several blocks to read. After filling one block fully, it will be optimized for reading.
	
	2. Concurrency Management
	Earlybird takes benefit of Java's memory model:
		Programe order rule.
		Volatile variable rule
		Transitivity.
	/Fig. 3 in the paper/
	In summary, it simplifies the concurrency management problem by adpoting a single-write, multiple-reader desing. The select use of a memory barrier around the maxDoc variable supports an easy-to-understand consistency model while imposing minimal sync overhead.

	The paper's address is here.
	http://www.umiacs.umd.edu/~jimmylin/publications/Busch_etal_ICDE2012.pdf
	
	
	
	