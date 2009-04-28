Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from turboconrad.planet-school.de ([194.116.187.5]:56611 "EHLO
	turboconrad.planet-school.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbZD1NfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 09:35:07 -0400
Received: from turboconrad.planet-school.de (turbolabarbara.planet-school.de [194.116.187.109])
	by turboconrad.planet-school.de (Postfix) with ESMTP id 30D5D11B2030
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 15:28:37 +0200 (CEST)
Received: from [138.246.14.80] (unknown [138.246.14.80])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: mail@philipp-wagner.com)
	by turboconrad.planet-school.de (Postfix) with ESMTP id 14ED8116DA7C
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 15:28:36 +0200 (CEST)
Message-ID: <49F70489.5070004@philipp-wagner.com> (sfid-20090428_153513_409292_4FEBDE78)
Date: Tue, 28 Apr 2009 15:28:41 +0200
From: Philipp Wagner <lists@philipp-wagner.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlagn: Microcode SW error detected.  Restarting 0x82000000.
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm running into a
Microcode SW error detected.  Restarting 0x82000000.
error with the iwlagn driver.

# uname -a
Linux 2.6.30-rc2-git6-master_20090416115717_67cb21e9-vanilla #2 SMP Thu
Apr 23 19:24:36 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux

I uploaded a (hopefully) complete log generated with the "debug=0x43fff"
at http://philipp.wagner.name/temp/iwlagn-microcodeerror.txt

Is this a known problem? I mainly experience this problem at university
with many access points for the same essid and it seems to happen more
often with encrypted communication (802.1x) - but that's only a feeling,
not a fact :)

Philipp
