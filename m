Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.syneticon.net ([213.239.212.131]:34606 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYBIKAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2008 05:00:44 -0500
Message-ID: <47AD79C2.2050309@wpkg.org> (sfid-20080209_100050_683658_F7F20DE4)
Date: Sat, 09 Feb 2008 11:00:34 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: prism54: Out of memory, cannot handle oid, card/socket may be
 faulty, or IRQ line too busy
References: <47ACD136.4030705@wpkg.org> <20080208221009.GA2919@tuxdriver.com>
In-Reply-To: <20080208221009.GA2919@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville schrieb:
> On Fri, Feb 08, 2008 at 11:01:26PM +0100, Tomasz Chmielewski wrote:
>> I just wanted to use a mini-PCI card using a prism54 module - however, it 
>> fails to bring the interface up with "Out of memory, cannot handle oid" and 
>> "Your card/socket may be faulty, or IRQ line too busy" messages.
> 
> I vaguely recall seeing an error like that when I used the wrong
> firmware.  What firmware are you using?

So, I tried with 2.7.0.0.arm firmware, and it's the same:

# dmesg
Loaded prism54 driver, version 1.2
PCI: Fixing up device 0000:00:02.0
eth2: resetting device...
eth2: uploading firmware...
eth2: firmware version: 2.7.0.0
eth2: firmware upload complete
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=ff020008 err=-145
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=ff020003 err=-145
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=10000000 err=-145
eth2: timeout waiting for mgmt response 250, triggering device
eth2: timeout waiting for mgmt response 225, triggering device
eth2: timeout waiting for mgmt response 200, triggering device
eth2: timeout waiting for mgmt response 175, triggering device
eth2: timeout waiting for mgmt response 150, triggering device
eth2: timeout waiting for mgmt response 125, triggering device
eth2: timeout waiting for mgmt response 100, triggering device
eth2: timeout waiting for mgmt response 75, triggering device
eth2: timeout waiting for mgmt response 50, triggering device
eth2: timeout waiting for mgmt response 25, triggering device
eth2: timeout waiting for mgmt response
eth2: mgt_commit_list: failure. oid=17000007 err=-145
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=19000001 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=10000002 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=19000004 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000000 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000001 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000002 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000004 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000005 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000006 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000007 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=12000003 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=150007e0 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=ff02000c err=-12
eth2: mgmt tx queue is still full
eth2: mgt_commit_list: failure. oid=ff020003 err=-12
eth2: mgmt tx queue is still full
eth2: mgt_update_addr: failure
eth2: mgt_commit: failure
eth2: interface reset failure
prism54: Your card/socket may be faulty, or IRQ line too busy :(



-- 
Tomasz Chmielewski
http://wpkg.org
