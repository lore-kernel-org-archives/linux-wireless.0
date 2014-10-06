Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:57162 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaJFPsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 11:48:41 -0400
Received: by mail-vc0-f173.google.com with SMTP id ij19so3328306vcb.32
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 08:48:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412600813.3098.11.camel@jlt4.sipsolutions.net>
References: <1411434889-1456-1-git-send-email-yeohchunyeow@gmail.com>
	<1412600813.3098.11.camel@jlt4.sipsolutions.net>
Date: Mon, 6 Oct 2014 23:48:40 +0800
Message-ID: <CAEFj987G4TVGaKV8KULO1U98sB5uDGrQALFsZZ6XizNrSnQSEw@mail.gmail.com> (sfid-20141006_174844_725716_6D5E5E43)
Subject: Re: [PATCH v4 1/2] iw: Allow user to provide freq during mesh join
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	Ashok Nagarajan <ashok.dragon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

There are actually two different patches. The latest one, both of them
are named as v4.

[PATCH v4 1/2] iw: Allow user to provide freq during mesh join
[PATCH v4 2/2] iw: Allow basic rates to be configured when joining mesh

----
Chun-Yeow

On Mon, Oct 6, 2014 at 9:06 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-09-23 at 09:14 +0800, Chun-Yeow Yeoh wrote:
>> Allow user to configure frequency and channel type during
>> mesh join command.
>
> I think I saw another v4 of this, was this meant to be v5?
>
> johannes
>
