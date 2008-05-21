Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:53547 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694AbYEUJfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 05:35:10 -0400
Received: from rufsun5.fkie.fgan.de ([128.7.2.5] helo=mailhost.fgan.de)
	by mailguard.fgan.de with esmtp (Exim 4.63)
	(envelope-from <Rogge@fgan.de>)
	id 1JykHT-0008MU-4C
	for linux-wireless@vger.kernel.org; Wed, 21 May 2008 11:06:43 +0200
Received: from mailserv1.fkie.fgan.de ([128.7.96.101] helo=mailserv1.lorien.fkie.fgan.de)
	by mailhost.fgan.de with esmtp (Exim 4.67 #7 (Solaris MB))
	id 1JykHT-0004nt-00
	for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 11:06:43 +0200
From: Henning Rogge <rogge@fgan.de>
To: linux-wireless@vger.kernel.org
Subject: Get adhoc signal strength and bandwith from userspace
Date: Wed, 21 May 2008 11:06:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200805211106.42682.rogge@fgan.de> (sfid-20080521_113517_234756_D7A0705F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm looking for an easy way to get average signal strength and bandwith=
 for=20
each communication partner in adhoc mode. I know this could be done wit=
h=20
radiotap headers, but this would require to parse all incoming frames, =
which=20
can consume lot's of cputime on embedded devices.

Is there a userspace interface to get the bandwith and average signal s=
trength=20
of the communication partners in the 802.11 layer ?

Henning Rogge

*************************************************
Diplom-Informatiker Henning Rogge
=46orschungsgesellschaft f=FCr
Angewandte Naturwissenschaften e. V. (FGAN)=20
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.: 0049 (0)228 9435-961
=46ax: 0049 (0)228 9435-685
E-Mail: rogge@fgan.de
Web: www.fgan.de
************************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Dr. rer. nat. Ralf Dornhaus (Vors.), Prof. Dr. Joachim Ender=20
(Stellv.)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
