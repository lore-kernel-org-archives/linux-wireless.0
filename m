Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43545 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbYJOUCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 16:02:54 -0400
Message-ID: <48F64C6B.5010801@openwrt.org> (sfid-20081015_220257_092434_1FC45795)
Date: Wed, 15 Oct 2008 22:02:51 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] minstrel: improve performance for non-MRR drivers
References: <48F624D7.4040802@openwrt.org> <20081015194803.GB27688@tuxdriver.com>
In-Reply-To: <20081015194803.GB27688@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Oct 15, 2008 at 07:13:59PM +0200, Felix Fietkau wrote:
>> This patch enhances minstrel's performance for non-MRR setups,
>> by preventing it from sampling slower rates with >95% success
>> probability and by putting at least 1 non-sample frame between
>> several sample frames.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>> This patch depends on the rate control API rewrite patch.
> 
> Hah!  Which one...? :-)
Should work with Johannes' v3, if it doesn't, please let me know ;)

- Felix
