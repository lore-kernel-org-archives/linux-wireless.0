Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:63314 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaEVPVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 11:21:36 -0400
Received: by mail-qg0-f50.google.com with SMTP id z60so5826890qgd.23
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 08:21:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400771757.4174.37.camel@jlt4.sipsolutions.net>
References: <3893194.GDQagdLGN9@desktop.local> <1400771757.4174.37.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Thu, 22 May 2014 17:21:15 +0200
Message-ID: <CAGnRvur6zFrUUbSLzC=PddHqO46k5RbQM+RY19o_hqZxbQnzHw@mail.gmail.com> (sfid-20140522_172139_577216_2B3002F3)
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@noack.us>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ups...

I thought I had found all this "stupid whitespace mistakes, I will
remove them in the next version of the patch... but I wanted a comment
if this is a good direction to go before we discuss how to change the
netlink interface to export the data of the former mpp_paths table.

Henning Rogge

On Thu, May 22, 2014 at 5:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 17:06 +0200, Henning Rogge wrote:
>> From: Henning Rogge <hrogge@gmail.com>
>>
>> This patch is a preparation for exporting the MPP data of the 802.11s
>> implementation via netlink to userspace. It unifies the content of the
>> mesh_paths and mpp_paths tables in mesh_pathtbl.c without changing
>> the behavior of the code.
>
> Code removal always *seems* good, but I can't really say much about
> this :-)
>
>>  void ieee80211s_stop(void);
>> +
>>  #else
>
> This I'd rather avoid though.
>
> johannes
>
