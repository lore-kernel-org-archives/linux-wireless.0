Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35077 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1BBLB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 06:01:28 -0500
Received: by pzk35 with SMTP id 35so1206132pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 03:01:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87r5btdsb8.fsf@purkki.adurom.net>
References: <4D45A583.3060605@davizone.at>
	<4D45B7B2.40001@davizone.at>
	<87r5btdsb8.fsf@purkki.adurom.net>
Date: Wed, 2 Feb 2011 13:01:27 +0200
Message-ID: <AANLkTimto_rYQfePQG8d2wJHeHwyoFSZLO_U4o+-ro=F@mail.gmail.com>
Subject: Re: [PATCH 00/18] wl1251: feature ports / monitor mode / packet injection
From: Grazvydas Ignotas <notasas@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: David Gnedt <david.gnedt@davizone.at>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	Yuri Ershov <ext-yuri.ershov@nokia.com>,
	Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Jan 31, 2011 at 5:08 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Hi David,
>
> David Gnedt <david.gnedt@davizone.at> writes:
>
>> Patch 01-03 fix some bugs.
>> Patch 04-09 contain some feature ports from Maemo Fremantle and wl1271.
>> Patch 10-18 implement (mainly) monitor mode and packet injection.
>
> How did you test the patches? For example, what hardware did you use
> etc.
>
> About the code from fremantle kernels. Few weeks ago nokia sent me
> privately the original patches from their internal git tree, I gave
> some comments and never heard back. So, in theory I should have all
> the fremantle patches somewhere in my email archives. I would just
> need to clean them up and send them here. I'll go over your patches
> and let's see what we should do.

I was the one trying to organize this, Luciano managed this from Nokia
side and Yuri (CCed) did the porting to newer kernels. However several
patches were missing attribution and things somehow got stuck there.

As for this series, I'll try to test them on pandora hardware over this week.
