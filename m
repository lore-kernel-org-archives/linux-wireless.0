Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37543 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbZDCLFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 07:05:35 -0400
Received: by fxm2 with SMTP id 2so926111fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 04:05:32 -0700 (PDT)
Message-ID: <49D5ED77.3030206@gmail.com> (sfid-20090403_130544_085732_2CD606E8)
Date: Fri, 03 Apr 2009 13:05:27 +0200
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
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we got another application on wireless. See below. Who has not done so 
yet, do not forget to apply as mentor at the LF.

    Till

--------------------

Title:  	 Impove Wireless Roaming
Student: 	Mircea Gherzan
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
Wireless roaming functionality is currently provided to mobile Linux 
users by the wpa_supplicant daemon. However, there is no assistance 
coming from the in-kernel wireless stack (mac80211). The roaming 
experience can be improved by providing such assistance in the form of 
scanning triggers. This project aims to design and implement such 
triggers and to modify the supplicant accordingly in order to enhance 
the roaming.
Content:
About myself

I'm a final year student in Computer Science at the Techical University of
Bucharest, Romania (graduation: June 2009). Becaouse of my result, I was 
invited
to work as an Undergraduate Teaching Assistant (UTA) in the CS department,
being part of the following teams:
* Operating Systems (Spring 2008, Spring 2009)
* Object Oriented Programming (Fall 2007, Fall 2008)
* Data Structures (Spring 2009)

I have completed the following internships:
* Vodafone Romania (Summer 2007) - UNIX scripting and development 
(CORBA, Oracle
   Call Interface)
* BitDefender (Summer 2008) - part of the Core Libraries team, I was 
doing C++
   coding and profiling for a high-performance web-server of internal use.

I am currently an intern at Ixia, part of the IxOS Linux team, doing kernel
programming (device drivers, networking, CryptoAPI).

I am looking forward to completing a M.Sc. Degree at the Techical 
University of
Dreden (Germany), for they have a very powerful group in Operating Systems.

I am present on the #linux-wireless channel with the nickname mike85.
Coding skills and setup

I use Debian Sid since a couple of years. My development machine is a T500
ThinkPad with an Intel IWL5300 AGN card. I also have access to two other
machines with Atheros and Intel wireless cards.

I have a strong command of C, C++, Java and Linux system programming. I 
am also
familiar with kernel programming, doing it now part of my internship and 
having
_practiced_ it at the university. I also have embedded programming 
skills, one
of my projects being a Bluetooth-controlled rover whose sources and 
schematics
now serve as learning material for younger students.

Apart from kernel/system programming, I am also familiar with various
technologies, like RMI, CORBA, RPC, RMI, OpenMP, MPI and with some scripting
languages (perl, python). I am comfortable with git (using it a lot at 
school)
and svn.

I have good knowledge of networking concepts, completing Cisco CCNA 
courses and
being among the top student in the networking related courses.

I therefore think I have the desired knowledge to complete the project.
Me and linux-wireless

My involvement in the Linux wireless community has been limited to 
testing and
submitting bug reports on the kernel bugzilla. As an user, I was an early
adopter (non mainline days) of the mac80211 stack and of the iwlwifi 
drivers.

Two years ago I started an open source project: MoTorr, a J2ME based 
BitTorrent
client. The project is hosted on SourceForge.

I have chosen to apply for the roaming project because it :
* involves both kernel-space and user-space programming
* adds huge value to the mobile end-user experience

An important factor in my decision was the feedback received on the mailing
list after my initial enquiry. The ideas of Holger Schurig and Helmut Schaa
helped me a lot in writing this application.

I expect my work to provide and smooth and power-efficient roaming experince
for mobile users. I am a laptop user myself, I would simply love my machine
to roam faster while moving around the campus.
The project

It aims to achieve better roaming capabilities for the users, by enabling a
better cooperation between the mac80211 and wpa_supplicant.

I have chosen this particular ideea from the list beacause it posed some
interesting challanges in terms of:
* right placement of the code (kernel- vs user-space)
* design (interface for different decision making algorithms)

I think I am suited to carry this project because I have experience in both
types of programming involved and I am familiar with the concepts of
802.11 networks. I also find the wireless kernel code well documented 
and easy
to understand and hack on.

Naturally, I am willing to invest at least 40h/week in the project 
during GSoC.
However, this number might increase, for I am aware of the problems 
arising in
kernel development and testing such code, but I am willing work as much as
required to keep up with the schedule and providy quality code.
A minor exception would be the first week, where I will probably assign only
30 hours: it is the last week of my intership at Ixia.

I see this project as my opportunity of becoming part of the kernel 
community
and therefore it is quite obvious that I  will continue to contribute after
GSoC ends.

Some technical considerations:
* from the very beginning I consider NM to be out of the picture
* the main decisions are:
     * _if_ to roam belongs to the kernel
     * AP selection should be done in wpa_supplicant
* "if" decision should be done considering:
     * signal strength
     * missed beacons
* for decisions based on signal stregth, drivers shoud be assigned a scaling
   factor in order to get a driver-independent threshold
* scanning hints should be relayed from the kernel to the supplicant
Preliminary Schedule

A final schedule will be discussed on the list upon acceptance.

* Before May 23rd:
     * get more familiar with kernel and wpa_supplicant code
     * read the O'Reilly book on 802.11 _in detail_
     * discuss the ideas even more on the mailing list
     * create a test setup at my house (at least 2 APs)
     * GeoClue integration research
     * start coding (why not?) if consesus on the mailing lists has been 
reached
     * set up a blog, wiki page and other communication means, if necessary
* May 23rd - June 1st:
     * design a common interface for roaming decision algorithms
         (like rate-selection)
     * deliverable: wireless-testing patch
* June:
     * write kernel triggers
     * nl80211 interface additions.
     * deliverables: patches for wireless-testing
* July - August 10th:
     * add support to the triggers in wpa_supplicant (generic and driver 
code)
     * GeoClue client behaviour in the supplicant
     * deliverable: wpa_supplicant patch
* August 10th onward:
     * integration testing
     * fine tuning, bugfixing
     * writing documentation
* After GSoC:
     * code clean-ups, refactoring, etc

Additional info: 	http://swarm.cs.pub.ro/~mgherzan/soc_roaming.txt

