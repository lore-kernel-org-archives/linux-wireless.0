Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:57277 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZGIRvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:51:09 -0400
Received: by qw-out-2122.google.com with SMTP id 9so122159qwb.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 10:51:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0907091048v665dcdf6i659e94de95038856@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	<6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com>
	<6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
	<20090707030719.GC7199@hash.localnet> <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
	<20090708114252.GG7199@hash.localnet> <6c354a1a0907090942o66c4e1b8ue2c952cf7ed7bf9a@mail.gmail.com>
	<b6c5339f0907090955v7b99a7ebq26e7cc67ab2493f5@mail.gmail.com>
	<43e72e890907091002r2dd36efevbfbce06155beb7e5@mail.gmail.com>
	<b6c5339f0907091048v665dcdf6i659e94de95038856@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Jul 2009 10:50:48 -0700
Message-ID: <43e72e890907091050p7bc08a25s86f9bb7a1c8740aa@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
To: Bob Copeland <me@bobcopeland.com>
Cc: Jasin Colegrove <j.wholesalesupply@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2009 at 10:48 AM, Bob Copeland<me@bobcopeland.com> wrote:
> On Thu, Jul 9, 2009 at 1:02 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>
>>>> $git bisect start v2.6.30-rc4 v2.6.29 -- drivers/net net/
>
>> I'd add net/mac80211 and net/wireless in there as well, just to be safe.
>
> net/ was already in there :)

Ah yes :)
