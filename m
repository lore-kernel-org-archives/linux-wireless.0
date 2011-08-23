Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51493 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab1HWPJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:09:21 -0400
Received: by yxj19 with SMTP id 19so154998yxj.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 08:09:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110823134932.GB9770@tuxdriver.com>
References: <1313250844-4526-1-git-send-email-zajec5@gmail.com>
	<CACna6rwoyPuwnzcw4BR5dmOiX9ogsTbquaG6qwRMZtLZytNnoA@mail.gmail.com>
	<20110823134932.GB9770@tuxdriver.com>
Date: Tue, 23 Aug 2011 17:09:20 +0200
Message-ID: <CACna6rwbNx-P1i4XhT587JM1AsB4SpoRx+qA2RK0e4VbQvM07w@mail.gmail.com> (sfid-20110823_170925_304124_22888B4E)
Subject: Re: [PATCH] b43: HT-PHY: init: add missing small-tables writes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 sierpnia 2011 15:49 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Tue, Aug 23, 2011 at 02:45:51PM +0200, Rafał Miłecki wrote:
>> W dniu 13 sierpnia 2011 17:54 użytkownik Rafał Miłecki
>> <zajec5@gmail.com> napisał:
>> >
>> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> > ---
>> > John: this one depends on
>> > [RFC][PATCH] b43: HT-PHY: allow writing longer tables with a single call
>> > , please apply the one above.
>>
>> John, I've asked you to apply the mentioned patch before this one. By
>> applying *just* this one you've broken build for ppl trying *BROKEN*
>> HT support.
>
> Please, _please_, _PLEASE_ stop doing this.  I process a lot of
> patches, and sometimes I will miss these directives.
>
> If your patch is not RFC, then don't post it as RFC.  If you post
> a patch as "Request For Comment" and I don't have any comments,
> I'm going to delete it.  If you later decide it is no longer RFC,
> then I've probably already deleted it.  So you need to re-post the
> patch as just "PATCH".
>
> I no longer have "b43: HT-PHY: allow writing longer tables with a
> single call".  If it is needed, then you need to repost it.

Sorry, I didn't know about this "RFC" rule. I expected patch to be
applied after spending a few days without comments. Will re-send in
the future.

-- 
Rafał
