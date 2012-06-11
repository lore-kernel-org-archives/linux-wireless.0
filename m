Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43481 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2FKTsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 15:48:40 -0400
Received: by obbtb18 with SMTP id tb18so7159992obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 12:48:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC6A68D.1010002@hauke-m.de>
References: <773DB8A82AB6A046AE0195C68612A319012CA16F@sbs2003.acksys.local> <4FC6A68D.1010002@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 11 Jun 2012 12:48:19 -0700
Message-ID: <CAB=NE6UxQ=w3shKs8pWRYsjPpTdMAN4Vs=a9jwkHsfTe-WVVDQ@mail.gmail.com> (sfid-20120611_214842_930199_89DD1445)
Subject: Re: Is there a changelog for compat wireless ?
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 30, 2012 at 4:00 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 05/30/2012 07:54 PM, Jean-Pierre TOSONI wrote:
>> Hello all,
>>
>> I am looking for indications as what is changing from one version of
>> compat-wireless to the next.
>>
>> The link for the changelog given at
>>  http://linuxwireless.org/en/users/Download#compat-wireless_ChangeLog
>> is broken.
>>
>> Is there some other place where I can find it ? ww.orbit-labs.org has
>> many, is it that the changes to the wireless software is not backported
>> in the same way to all (supported) versions of the kernel ?
>>
>> Thanks,
>>
>> Jean-Pierre Tosoni
> Hi
>
> The changelog for compat-wireless is here:
> https://github.com/mcgrof/compat-wireless/commits/master
> for compat here:
> https://github.com/mcgrof/compat/commits/master
> and for wireless-testing here:
> https://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=shortlog

And then we have unified changelogs for stable releases these are
listed on the stable page:

http://wireless.kernel.org/en/users/Download/stable/

For example:

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.4/ChangeLog-3.4-rc3

We also now have ckmake logs which are compile test logs against all
supported kernels, we only post stable releases / linux-next daily
releases if all compile tests succeed.

  Luis
