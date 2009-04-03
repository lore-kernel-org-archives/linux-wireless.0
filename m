Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53524 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZDCTM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 15:12:27 -0400
Received: by fxm2 with SMTP id 2so1109155fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 12:12:23 -0700 (PDT)
Message-ID: <49D65F93.40105@gmail.com> (sfid-20090403_211229_272804_A19FA521)
Date: Fri, 03 Apr 2009 21:12:19 +0200
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

we got another application on wireless. See below. Who has not done so
yet, do not forget to apply as mentor for the LF at
http://socghop.appspot.com/.

    Till

--------------------

Title:  	Automated test bed for WiFi
Student: 	vipin m
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
Presently none of the open source drivers are WiFi (Wireless Fidelity)=20
certified. Getting that certification is costly too.UNH-IOL brings out=20
comprehensive test plans for protocol conformance testing. But=20
unfortunately the tools used by UNH-IOL are not available publically.An=
d=20
the final goal of this project is to test the IEEE 802.11n based open=20
source device drivers and devices (AP and clients) in terms of protocol=
=20
conformance and interoperability with various vendors.
Content:

About Me -

I am Vipin M, doing My MS by Research in Wireless Communication  at=20
AU-KBC Research Center of Anna University Chennai india.

I finished my B.E - Electronics and Communication Engineering (2000 -=20
2003) Tamilnadu, India

 From April 2004 to January 2006 as Project Engineer in Network Securit=
y=20
Research Group and System Administrator at AU=E2=80=93KBC Research Cent=
re. At=20
present i parally doing network administartion work for center with my=20
MS studies.

Exprence -

IEEE 802.11n Power Save Simulation - Simulation study of HT-MAC Power=20
Save in Matlab.
Building Custom Linux distribution - Building a custom Linux for=20
=46irewall, Development, Mail and Web Servers.
Remote File Integrity Check  (RFiC) -  Software tools to check the file=
=20
integrity of local files in Linux systems developed using c.
Dynamic Password Authentication System ( DPAT) - Used for Two Factor=20
authentication. Hardware Token in client side and web server on server =
side.
Detection and Analysis of Burst Signal from LDV  - Bust signal analyzer=
=20
using LabView / Matlab for Laser Doppler Velocimeter.

My irc.freenode.net id is vipintm.

Code skill and other details -

I use C for most of the simulation as part of my research work, work=20
around C++ and Qt for simple GUI. Do scripting using bash/perl also for=
=20
  the network administartion task and automation of our internal testin=
g=20
and expiriments.

I use AMD Athlon X2 based Acer lapto with Merlin based Atheros ( Athero=
s=20
AR9280 ) card in express pci and Brodcome (BCM4311 ) inbuild card with=20
fedora 10 os. I use latest compiled kernel from wireless-testing.

I have a good understanding of IEEE 802.11 protocoles. And currentely i=
=20
am in a lerning process of mac80211 based linux-wireless stack.

We use SVN for most of the internal project and now git through linux

Till date none of my work is not there in public domain. But used lot o=
f=20
open source tools in the development.

Project Proposal - Automated test bed for WiFi



The reson to chose this project

Presently none of the open source drivers are WiFi (Wireless Fidelity)=20
certified. Getting that certification is costly too. WiFi Alliance (WFA=
)=20
also majorly focuses on the interoperability among the multiple vendors=
=2E=20
UNH-IOL brings out comprehensive test plans for protocol conformance=20
testing. But unfortunately the tools used by UNH-IOL are not available=20
publically.

What do you want to achieve?

=46inal goal of this project is to test the IEEE 802.11n based open sou=
rce=20
device drivers (such as ath9k, iwlagn etc) and devices (AP and clients)=
=20
in terms of protocol conformance and interoperability with various vend=
ors.

If you are proposing a project of your own, what is unique about it?

We created a draft version of test plans using UNH-IOL and other genera=
l=20
test senirious. We added plans for Stress and Regression testing.

This enhanced test plans are developed to help free-lancers to evaluate=
=20
the functionality of the MAC (Medium Access Control) layer. And also=20
ensures that the device/driver obeys the specification defined in the=20
IEEE standard. Access point (AP) as well as client cards can be tested=20
using our test bed.

Each and every bit of a frame can be manipulated in our injection tool.

What makes you suited to carry the project?

We had experience in testing performance of outdoor and indoor based=20
WiFi products. Presently we are doing minimal testing on mac80211 based=
=20
driver as we have enough hardware resources. Meantime we found=20
interesting to develop a complete test bed which can do most of the tes=
t=20
automatically.



What do you expect from your implementation?

We are expecting the following two tools will be the outcome of this=20
project.

    1.

       Injector

This tool is used to transmit MAC frames according to the test plans in=
=20
controlled and interactive manner. Data rate, channel and other=20
necessary parameters also can be configured. Development of this tool i=
s=20
already in progress.

    1.

       Test Console:

Test parameters such as device type (AP, Client), hardware address of=20
the device will be configured in the console. Once these configurations=
=20
are done the tests runs automatically based on the test plan. It can=20
directly interact with Wireshark and Injector to get the results and=20
then analyses the results. Finally generate the complete report based o=
n=20
the collected results. Development of this tool is not yet started.

Why have you chosen your development idea?

To implement all the test plans we need the above mentioned tools. With=
=20
the help of console we can automate the testing process.



Tentative schedule -



As we have a simple syetm for injecting packet, we like to continu to=20
extent it to ieee 802.11n packets and make
the frame work so we like to discuss and generate a schedule.


REF : http://www.iol.unh.edu/
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
