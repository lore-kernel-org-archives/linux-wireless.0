Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:9406 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZC3Wrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 18:47:41 -0400
Received: by fg-out-1718.google.com with SMTP id 16so416332fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 15:47:39 -0700 (PDT)
Message-ID: <49D14C07.6010400@gmail.com> (sfid-20090331_004748_437793_C4BE34C1)
Date: Tue, 31 Mar 2009 00:47:35 +0200
From: Till Kamppeter <till.kamppeter@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Jussi Kukkonen <jku@linux.intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Dan Williams <dcbw@redhat.com>
Subject: Google Summer of Code 2009: Another wireless application
References: <68f4d6130903241108j590d49adj10446169f7c3c06b@mail.gmail.com> 	<43e72e890903241256l39f5b1f9i49ce2b7a6e8099c3@mail.gmail.com> 	<49CD0FCF.3060706@gmail.com> <43e72e890903271126p7a302460lffdd5cd8d6ebe807@mail.gmail.com>
In-Reply-To: <43e72e890903271126p7a302460lffdd5cd8d6ebe807@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we got another application on wireless. See below. And do not forget to=
=20
apply as mentor at the LF.

    Till

--------------------

Title:  	Automation of testing using mac80211_hwsim and Orbit
Student: 	Qasim Javed
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
Name: Qasim Javed
Affiliation: University of Texas at Dallas
Enrollment: Computer Science Ph.D. Student
=46reenode IRC nick: nixbox
Email address: qasimj@gmail.com

I am primarily interested in "Automation of testing using mac80211_hwsi=
m=20
and Orbit". I have been exploring the mac80211 stack along with the=20
ath5k drivers which has enabled me to learn about the workings of the=20
stack. Also, I am familiar with networking testbeds. I have worked on=20
Emulab networking testbed before and have also worked on a testbed=20
project in our lab. This has made it easy for me to learn and use the=20
Orbit testbed.

Moreover, by virtue of my research work in wireless networking which=20
includes IEEE 802.11, I am already familiar with the workings of the=20
protocol. This puts me in a very good position to start working on this=
=20
project.

I have already tried some tests using tools such as Andy green's=20
packetspammer. Specifically, I have tested the power saving mode on STA=
s=20
and verified that the AP buffers the packets when the STA is in power=20
save mode 2.

This proposal lists the test cases that should be done in my opinion.=20
However, an interaction with the Linux Wireless community will enable m=
e=20
to refine these test cases and come up with a set which can really help=
=20
the mac80211 and wifi device driver developers.
Content:

About me
I am currently a Ph.D. student in the Computer Science Department at th=
e=20
University of Texas at Dallas. I work in the Distributed Systems lab [1=
]=20
where I am advised by Dr. Ravi Prakash. We work on problems in wireless=
=20
networking, specifically, MAC layer issues in IEEE 802.11 and wireless=20
sensor networks.  I am also a teaching assistant for the Advanced=20
Operating Systems course offered in the computer science department=20
during Spring 2009 where I am responsible for creating Linux kernel=20
projects and grading them. I graduated with a Masters degree in compute=
r=20
science from the University of Texas at Dallas in Spring 2007. Prior to=
=20
this, I completed Bachelors in computer science from National Universit=
y=20
of Sciences and Technology, Pakistan in 2004. I have been using the=20
Linux operating system and developing applications for it since 2002. M=
y=20
undergraduate project was a network intrusion detection system develope=
d=20
for Linux using C and C++ programming languages.

Programming Languages and Platforms
I have been developing applications in C and C++ for the Linux Operatin=
g=20
System on the Intel and AVR32 platforms. I am also familiar with Bash,=20
Ruby, and TCL scripting languages. I use ruby for a lot of things=20
including web scraping, data analysis and quick application prototyping=
=2E=20
Most of my TCL work involves writing simulation scripts for network=20
simulator 2. I have also used TCL to run experiments on the Emulab=20
networking testbed.

Recent Development Experience
I have been involved in the development of Texas Network Testbed=20
project[2]. I was responsible for developing a communications library=20
for the testbed software in C++. I have also ported the open source=20
Contiki operating system [4] for wireless sensor networks to the EM2420=
=20
platform which consists of an Atmel 128L microcontroller along with=20
CC2420 IEEE 802.15.4 radio. I have implemented a distributed consensus=20
protocol in C using the Contiki operating system for wireless sensor=20
nodes. Crossbow Telos-B motes were used as the implementation platform.=
=20
I conducted experiments and evaluated the performance of the protocol.

As a part of my research work, I have explored the new mac80211 Wifi=20
networking stack in the Linux Kernel. Most of the work was done to=20
understand the new ath5k driver, how it interacts with mac80211, and th=
e=20
implementation of rate control algorithms. I have tinkered with the=20
drivers, specifically, playing with how noise floor calibration works=20
and understanding the Automatic Gain Control mechanism. Most of my=20
implementation work will start from the Fall semester this year. Workin=
g=20
on this testing project will be a great opportunity for me as I will be=
=20
well prepared for the upcoming semester and also serve the Linux=20
Wireless developer and user community.

I have also worked on the Emulab networking testbed. Specifically, I ha=
d=20
written ns-2 style TCL scripts to test a consensus protocol on both=20
wired and wireless networks. I evaluated the performance of the protoco=
l=20
by using the results from the experiments.

Idea
I am interested in =E2=80=9CAutomation of testing using mac80211_hwsim =
and=20
Orbit=E2=80=9D. I selected this project because it is very relevant to =
the work=20
that I have been doing recently. Also, it will provide me with a great=20
opportunity to further my knowledge of the mac80211 Wifi networking=20
stack. My goal is to ease the task of mac80211 and Wifi device driver=20
developers by providing them an automated test suite. The test suite=20
will allow the developers to test the changes they have made to the=20
mac80211 stack.

Setup
Since I have been exploring the mac80211 stack and the ath5k drivers, I=
=20
have the latest wireless-testing tree on my Fedora machine. I also use=20
OpenGrok [3] source code search and reference engine for navigating=20
through the Linux kernel source code. I have compiled and tested=20
mac80211_hwsim from the latest wireless-testing git repository. I have=20
also used tcpdump to see all the packets in the "air" via the global=20
monitoring netdevice hwsim0. Moreover, I have experimented with Andy=20
Green's packetspammer tool.

=46or power save mode testing, I created three radios using mac80211_hw=
sim=20
kernel module's "radios" parameter. One of the radios was configured as=
=20
an AP, while the other two were configured as STAs. Both of the STAs=20
were associated with the AP. Debugfs was mounted and one of the STAs wa=
s=20
put into power save mode 2. It was noted that "num_sta_ps" debugfs entr=
y=20
on the AP was incremented as a result of the mode change on the STA. Th=
e=20
destination MAC address in the Packetspammer tool was modified so that=20
it sent frames to the STA in power save mode. It was noted that=20
"total_ps_buffered" debugfs entry on the AP interface was incremented=20
whenever a packet was injected on the monitor interface associated with=
=20
the STA which was not in Power Save mode.

To summarize, I have tried the following configurations:

1. One AP, one STA, no authentication
2. One AP, one STA, WPA2, CCMP
3. One AP, one STA, WPA2, TKIP
4. One AP, one STA, WPA2, TKIP on channel 1 and one AP, one STA, WPA2,=20
CCMP on channel 11
5. One AP, two STAs, WPA2, CCMP, one STA in Power Save mode 2.

I have familiarized myself with the Orbit testbed. That includes,=20
reserving slots, setting up an experiment, creating topologies,=20
collecting results using the OML (Orbit Measurement Library) and=20
analyzing the results.  As I am already familiar with Ruby, I was able=20
to grasp the syntax of Orbit scripts easily.

Open Source contribution
Recently, I have been involved with the Contiki open source operating=20
system for wireless sensor networks. I ported the OS to the EM2420=20
wireless sensor nodes which were sold by Ember Corporation. These nodes=
=20
are equipped with an Atmel 128L microcontroller and a CC2420 radio for=20
communications using the IEEE 802.15.4 protocol.

Project
I have chosen to work on =E2=80=9CAutomation of testing using mac80211_=
hwsim and=20
Orbit=E2=80=9D. My recent exploration of the mac80211 stack and ath5k d=
rivers is=20
an important reason to choose this project. I think that this project=20
will be very beneficial to the developers who are working on mac80211=20
and device drivers that use mac80211 and has the potential to save time=
=20
and effort. Also, it will provide me with an opportunity to contribute=20
to a very useful open source project and also enhance my understanding=20
of the mac80211 stack.

I have been doing research in wireless networking, specifically IEEE=20
802.11 and IEEE 802.15.4. I have become familiar with both these=20
protocols as a result of my research work. Also, both these protocols=20
were formally taught in the Mobile Computing course which I had taken=20
during my Masters. As most of my work has been at the MAC layer, I am=20
familiar with the CSMA/CA based medium access mechanism which includes=20
the random backoff procedure and the behavior of contention window.=20
Also, I understand active and passive scanning procedures and how probe=
=20
requests are used in the former while the latter depends on hearing=20
beacons. Moreover, I am also familiar with Enhanced Distributed Channel=
=20
Access (EDCA) which is a mechanism to provide QoS for IEEE 802.11=20
networks. I have worked on Infrastructure-based network configurations=20
as well as IBSS or Ad-hoc configurations. I am comfortable with the=20
workings of IEEE 802.11 and can learn things as and when needed. I also=
=20
feel comfortable browsing the standards document for the information I=20
need regarding the workings of IEEE 802.11 protocol. Also mention IEEE=20
802.11d and IEEE 802.11h

As a teaching assistant for the Advanced Operating Systems course at th=
e=20
University of Texas at Dallas, I have been responsible for teaching=20
students the basics of Linux Kernel Programming. This includes Linux=20
Kernel Module Programming, System Calls, Netfilter, synchronization=20
primitives within the kernel.

Automation of testing involves two things:
1. Writing the test cases, which involves writing shell scripts for=20
hostapd and wpa_supplicant.
2. Validating the tests, which requires finding out the result of the=20
scripts, whether the test succeeded or failed.

Validation of tests depends on the kind of tests being conducted.=20
Essentially, there are two types of tests. Firstly, tests that can be=20
done without transmitting or receiving anything, such as whether Master=
=20
or AP mode is supported by the card. Secondly, tests that require=20
transmission or reception of frames, for example, whether power save=20
mode works correctly.

=46or the first type of tests, validation can be done using the output =
of=20
"iw" utility. For the second type of tests, scripts need to transmit=20
relevant frames via frame injection and then the entries in debugfs can=
=20
be used for validation of these tests. An example of this has been=20
provided earlier where I had tested the Power Save mode. In some cases,=
=20
especially those where there are no relevant debugs entries, peeking=20
into the traffic going on between the nodes may be required. This can=20
done by writing a program which uses the pcap library to switch the=20
relevant interface to monitor mode and then apply rules. These rules ca=
n=20
be written by extending expect.

1. Automating the testing of mac80211 and cfg80211 using mac80211_hwsim

The IEEE 802.11 standard specifies Protocol Implementation Conformance=20
Statement (PICS) proforma in Annex A of the standards document. This ca=
n=20
be used to select tests that would be necessary for testing the=20
conformance of the implementation with the standard. These tests can=20
serve as the starting point for automating the testing of mac80211.=20
=46ollowing are some of the things that can be tested.

IEEE 802.11d
Regulatory tests (mac80211_hwsim module regtest parameter)
Write a script that performs the different regulatory tests supported b=
y=20
mac80211_hwsim. According to the documentation, all the tests can be=20
performed with a maximum of 6 radios.

Open System Authentication
Test using hostapd and wpa_supplicant, validation using interface=20
properties, such as whether the STAs associated with the AP.

Shared Key Authentication
Test using hostapd and wpa_supplicant, validation using interface=20
properties, such as whether the STAs associated with the AP. Debugfs=20
entries in the "keys" folder can also be used for verification.

Deauthentication
Test using hostapd and wpa_supplicant, validation using interface=20
properties, such as whether the STAs dissociated from the AP.

Duplicate Detection
Test using modified PacketSpammer tool, validation using debugfs entry.

=46ragmentation/Defragmentation
=46ragmented frames can be created using modified PacketSpammer tool an=
d=20
debugfs entries such as "received_fragment_count" can be utilized for=20
validation

Rejection of packets with incorrect CRC
Again, debugfs can be used to validate this. We will need to create a=20
packet with a wrong checksum and inject it on an interface.

Power Save
Debugfs can be used to test Power Saving mode. Every STA created using=20
mac80211_hwsim has a "ps" entry. This can be used to change the power=20
saving mode for the STA. Each AP also has an entry called "num_sta_ps"=20
which indicates the number of STAs associated with this AP that have=20
changed to Power Save mode. Moreover, "total_ps_buffered" can be used t=
o=20
check how many frames are buffered for an STA in the power save mode.=20
These entries in combination with modified PacketSpammer tool can allow=
=20
testing of the power save mode. I have done some manual tests using=20
these entries already.

RTS/CTS
Broadcast/Multicast
MAC Level Acknowledgements
Association/Re-association
Probe request/response
Suspend/Resume

IEEE 802.11h
Measurement reports
Quiet intervals
Channel Switching

2. Automating the testing of Wifi device drivers using the Orbit testbe=
d

Orbit testbed will be used for testing various device drivers. Some of=20
the things that can be tested for each device driver are as follows:

Transmit power levels support
Multirate Support
Extended Rate PHY support
QoS support
unicast at different rates
broadcast/multicast at different rates in the BSSBasicRateSet

Orbit Traffic Generator (OTG) can be used to test unicast at different=20
rates and broadcast at different rates in the BSSBasicRateSet.=20
Validation of tests can be performed by checking the current rate being=
=20
used by the driver. Also, statistics available in debugfs can be used=20
for validation.

As mentioned on the Wiki, sandboxes on the Orbit testbed can be used fo=
r=20
the above tests as they have a nice mix of hardware available for testi=
ng.

Libmac [5] provides frame capture and injection facilities. It also=20
allows manipulation of a subset of wireless interface parameters at bot=
h=20
aggregrate and per-frame levels. This can be very useful for testing=20
device drivers on the Orbit testbed. Test cases can be written so that=20
they use libmac to inject packets with certain field values. This allow=
s=20
virtually limitless possibilities for testing on the Orbit testbed. A=20
good way to approach the problem would be to write an application based=
=20
on libmac. Shell scripts can then be written to use the application to=20
perform certain tests and validate them.

Time
If selected, I will be working full time 40 hours/week on this project.

Schedule
This is just a preliminary schedule. I will create a more detailed=20
schedule after interacting with the Linux Wireless developer community=20
as I will be more prepared and confident about what exactly has to be=20
implemented.

1-2 weeks, Interacting with the Linux Wireless community to come up wit=
h=20
possibly better test cases and ideas regarding the project
3-4 weeks, test case implementation for mac80211_hwsim, this includes=20
writing shell scripts, for testing and validation
3-4 weeks, test case implementation for orbit testbed
2 weeks, testing and debugging
1-2 weeks, website showing test results for mac80211 and device drivers


References
[1] http://dslab.utdallas.edu/
[2] http://dslab.utdallas.edu/tnt.php
[3] http://opensolaris.org/os/project/opengrok/
[4] http://www.sics.se/contiki/
[5] http://www.orbit-lab.org/wiki/Documentation/Libmac
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
