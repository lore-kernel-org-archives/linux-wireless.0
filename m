Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:11060 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbZCRBRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 21:17:45 -0400
Received: by yw-out-2324.google.com with SMTP id 3so280283ywj.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 18:17:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Mar 2009 12:17:42 +1100
Message-ID: <af5afd160903171817v6a6ec50al6e933985628e7674@mail.gmail.com> (sfid-20090318_021750_056725_18EECBC0)
Subject: compile error.
From: Dennis Kavadas <ipguy@kavadas.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi all

i'm currently running a CentOS5 server with kernel version 2.6.18-92.1.22.el5

i've downloaded
http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-old.tar.bz2
and when trying to complie i get the below error.

--snip
/usr/local/src/compat-wireless-2.6-old/include/linux/compat_autoconf.h:10:2:
error: #error Compat-wireless requirement: Linux >= 2,6,21
In file included from <command line>:1:
--snip

i'm sure i downloaded the correct driver version as i attempted the
download and compile a few times.

any suggestions ?
