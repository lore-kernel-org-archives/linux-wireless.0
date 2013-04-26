Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:51969 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab3DZQ5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 12:57:47 -0400
Message-ID: <88f1398e0d87f1c79c5781f07bb7fb20.squirrel@www.infidigm.net> (sfid-20130426_185751_642236_BF09FE6E)
Date: Fri, 26 Apr 2013 13:41:05 -0400
Subject: Ath6kl:  how to set custom mac address?
From: drwho@infidigm.net
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qca.qualcomm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there a way to set the mac address on an ath6kl device?  For example
when loading the module?

insmod ath6kl_core.ko mac=55:66:77:88:AA:BB

or with ifconfig / ip?

Jon



