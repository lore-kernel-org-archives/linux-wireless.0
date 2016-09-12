Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51347 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932232AbcILKFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:05:07 -0400
Subject: Re: [PATCH] mac80211: fix sequence number assignment for PS response
 frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20160904160059.66297-1-nbd@nbd.name>
 <1473674327.29016.3.camel@sipsolutions.net>
 <afb51baf-ec2d-3600-9e5b-f406b9e836b7@nbd.name>
 <1473674624.29016.4.camel@sipsolutions.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <521f75cd-2203-efc0-77c9-d9f7b6c4079f@nbd.name> (sfid-20160912_120632_735573_09BED257)
Date: Mon, 12 Sep 2016 12:05:04 +0200
MIME-Version: 1.0
In-Reply-To: <1473674624.29016.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-12 12:03, Johannes Berg wrote:
> 
>> Hm, I guess I didn't think of that. I guess this potential issue will
>> go away once we get Toke's tx handler reorder patch fixed, rebased
>> and integrated.
>> 
> 
> I don't really see how that helps?
It replaces the changes that I made.

- Felix
