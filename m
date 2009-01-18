Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57604.mail.re1.yahoo.com ([66.196.100.86]:20246 "HELO
	web57604.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932174AbZARRlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 12:41:47 -0500
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
Date: Sun, 18 Jan 2009 09:41:46 -0800 (PST)
From: Deuce <the_deuce@yahoo.com>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
To: Deuce <the_deuce@yahoo.com>, Samuel Ortiz <samuel@sortiz.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <358756.9016.qm@web57604.mail.re1.yahoo.com> (sfid-20090118_184152_139422_7F67685E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'll try out the latest wireless-testing, but I am skeptical.


Wireless-testing as of master-2009-01-16 has some issues still.

I can see "Error sending REPLY_SCAN_CMD: time out after 500ms" and "Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms" in the output.  However, something hangs when I try to log in via GDM.  The above get printed out periodically, but I don't seem to get to the desktop.

Jason



      
