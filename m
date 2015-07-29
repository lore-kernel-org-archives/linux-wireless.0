Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:54473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbbG2UD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 16:03:57 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "apoc@keemail.me" <apoc@keemail.me>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: [linuxwifi] Random connection loss
Date: Wed, 29 Jul 2015 20:03:40 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E7DB4D7@hasmsx107.ger.corp.intel.com> (sfid-20150729_220401_196082_04DFAFD2)
References: <JvQNrDf----0@keemail.me>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 07/29/2015 10:57 PM, apoc@keemail.me wrote:
> I'm not quite sure how to trace the problem to its roots.
> 
> My wireless connection is disconnected and reconnects again. I can't
> reproduce this nor can I tell at what rate it disconnects.
> 
> I didn't experience it before upgrading the kernel from 3.16.0-4 to 4.0.0-2.
> The upgrade has been suggested in the **iwlwifi irc channel due to
> another problem.
> 

I wasn't aware about this channel :)

What does ethtool -i wlan0 say?

> $ uname -a
> Linux rytlock 4.0.0-2-amd64 #1 SMP Debian 4.0.8-2 (2015-07-22) x86_64
> GNU/Linux
> 
> What logs may I look into, to find the issue?
> 
> regards,
> apoc
