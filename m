Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:41449 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbYLLLbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 06:31:32 -0500
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1LB6Ey-00057v-DO
	for linux-wireless@vger.kernel.org; Fri, 12 Dec 2008 12:31:28 +0100
Message-ID: <49424B7A.9060700@redhat.com> (sfid-20081212_123136_927918_114DFF6A)
Date: Fri, 12 Dec 2008 12:31:06 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: reinette chatre
	<public-reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@hugh.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: iwlagn interrupt problem
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>	 <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>	 <1228929548.18730.21.camel@rc-desk>	 <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com>	 <49424419.1090103@redhat.com> <c072ca310812120323r2c92420di5a138ae6265d567f@mail.gmail.com>
In-Reply-To: <c072ca310812120323r2c92420di5a138ae6265d567f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Alexander E. Patrakov napsal(a):
> 2008/12/12 Zdenek Kabelac <zkabelac@redhat.com>:
>> I assume that this backtrace I've got with 2.6.28-rc7 is the same issue ?
> 
> No, this is different. My issue is with unacceptable latency when
> bringing the interface down. In your dmesg, the interface was never
> brought up or down.
> 

Hmm - it was something like an hour after resume when the problem started,

Here is timed part of the same backtrace:

[65627.782972] wlan0: associate with AP 00:11:d8:da:65:40
[65627.785569] wlan0: RX ReassocResp from 00:11:d8:da:65:40 (capab=0x401 
status=0 aid=8)
[65627.785576] wlan0: associated
[69541.209873] wlan0: No ProbeResp from current AP 00:11:d8:da:65:40 - assume 
out of range
[69541.810104] iwl3945: Error sending REPLY_SCAN_CMD: time out after 500ms.
[69542.309861] iwl3945: Error sending REPLY_RXON_ASSOC: time out after 500ms.


The begging of my trace looked similar.

Should I open new bugzilla separately ?

Zdenek

