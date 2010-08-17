Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58249 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab0HQW42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 18:56:28 -0400
Message-ID: <4C6B1395.2030208@hauke-m.de>
Date: Wed, 18 Aug 2010 00:56:21 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Subject: Re: [PATCH 0/3] compat-wireless: miscellaneous fixes
References: <1282069869-22300-1-git-send-email-hauke@hauke-m.de> <AANLkTinS=nXje5hJ=Eq4AuXvMUEhDbquB=C_oDXA+pHk@mail.gmail.com>
In-Reply-To: <AANLkTinS=nXje5hJ=Eq4AuXvMUEhDbquB=C_oDXA+pHk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 18.08.2010 00:02, schrieb Luis R. Rodriguez:
> On Tue, Aug 17, 2010 at 11:31 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> This was build tested in combination with the patches to compat.
>>
>> Hauke Mehrtens (3):
>>  compat-wireless: deactivate namespace
>>  compat-wireless: make compat-2.6.37.c build
>>  compat-wireless: fix hidp_output_raw_report
> 
> Great thanks! Applied and pushed all out. Are any of these stable
> fixes into the respective stable branches of compat-wireless.git? How
> about the compat.git ones?
> 
>   Luis

Thanks for applying.

Only compat-wireless: fix hidp_output_raw_report is needed in stable.
The other patches are not needed in stable for now, they are for some
changes made after 2.6.36.

Hauke
