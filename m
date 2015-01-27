Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.devonsuperstore.com ([8.20.30.154]:49016 "EHLO
	mx1.devonhealth.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbbA0O2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:28:15 -0500
From: Jason Plum <jplum@devonit.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"burton.b.williams@gmail.com >> Burton Williams"
	<burton.b.williams@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 27 Jan 2015 09:19:36 -0500
Subject: RE: RTL8192ee
Message-ID: <B57A220D1EE1644685BA9AD5C790D205421EDC730D@SOUTHSIDE.devonintlgroup.com> (sfid-20150127_152817_968427_D602052C)
References: <54C6F65A.90009@lwfinger.net>
In-Reply-To: <54C6F65A.90009@lwfinger.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

I know that to some degree I am jumping this chain. That being said, please allow me to offer encouragement in the development of the rtl8192ee, rtl872ae, and the other members of the rtlwifi_new github.

I have been using these myself, and keeping them in my sights as my commercial product that has to support these drivers is being developed. There are some hiccups as is to be expected, but your work is greatly appreciated. I strive to keep our product as free of vendor proprietary code as much as possible and you work with rtlwifi_new and the available integration with multiple revisions of the kernel has been a recent key to that effort.

Jason Plum
Sr. Software Engineer
Devon IT
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Larry Finger [Larry.Finger@lwfinger.net]
Sent: Monday, January 26, 2015 9:22 PM
To: burton.b.williams@gmail.com >> Burton Williams
Cc: linux-wireless
Subject: RTL8192ee

Burton,

I inadvertently deleted your E-mail, thus I cannot reply to it.

I am sorry that you have not had access to a driver for your wireless card. The
initial driver was accepted into Linux in May 2014 in staging. It was probably
not available to you because your distro is one of those that does not enable
staging drivers. Perhaps you should consider a different distro.

In addition to that driver, another version of the one in kernel 3.18 was made
available in a GitHub repo that was created in August 2014. That one contains
all the newest versions, and was the source of the changes introduced in kernel
3.18.

I have worked very hard on getting these drivers into the kernel. Comments like
yours make me wonder if it has been worth my effort.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html