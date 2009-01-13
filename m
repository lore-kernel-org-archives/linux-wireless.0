Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:53082 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZAMByT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 20:54:19 -0500
Received: by ewy10 with SMTP id 10so11831806ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 17:54:17 -0800 (PST)
Message-ID: <2d0a357f0901121754y16806d8cm59f61f74626c6a50@mail.gmail.com> (sfid-20090113_025424_456327_B9CD8D46)
Date: Tue, 13 Jan 2009 02:54:16 +0100
From: "Sedat Dilek" <sedat.dilek@googlemail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [master-2009-01-12] compiler-error in 'drivers/net/irda/donauboe.c'
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <496BF076.7000601@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <2d0a357f0901121657s1ea091b6m824e8f939be2d51d@mail.gmail.com>
	 <496BE899.7010406@oracle.com>
	 <2d0a357f0901121715y2aedbeecs9819688f275df25c@mail.gmail.com>
	 <496BF076.7000601@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh cool and thank you for the information!
Finally, it will be in 2.6.29-rc1-git3 then :-).
Anyway, it would be nice to have a wl.git-tree which is compilable
concerning net-* stuff.
But, it's hard to expect such thing from a very early rc1-kernel :).

-SD

On Tue, Jan 13, 2009 at 2:37 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Sedat Dilek wrote:
>> No, it's not mainline - I checked 2.6.29-rc1-git{1|2}.
>> But, it is in net-2.6.git [1] if you mean that by mainline :).
>>
>> -SD
>>
>> [1] irda: fix incomplete conversation to internal stats
>> http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=216c32d4407ea6951d6832773fdb3de058e12c62
>>
>> On Tue, Jan 13, 2009 at 2:04 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> Sedat Dilek wrote:
>>>> Hi,
>>>>
>>>> I could not compile latest wl.git due to problems in
>>>> 'drivers/net/irda/donauboe.c'.
>>>> A fix and description is given in [1].
>>>> Hope this helps other people.
>>>>
>>>> Regards,
>>>> Sedat
>>>>
>>>> [1] http://patchwork.kernel.org/patch/1791/
>>> The patch was just merged into mainline.
>
> I mean that it was just merged minutes ago:
>
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=216c32d4407ea6951d6832773fdb3de058e12c62
> Commit:     216c32d4407ea6951d6832773fdb3de058e12c62
> Parent:     c59765042f53a79a7a65585042ff463b69cb248c
> Author:     Alexander Beregalov <a.beregalov@gmail.com>
> AuthorDate: Thu Jan 8 16:42:08 2009 -0800
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Sun Jan 11 00:01:31 2009 -0800
>
>    irda: fix incomplete conversation to internal stats
>
>    Fix for commit af0490810c (irda: convert to internal stats)
>
>
> --
> ~Randy
>
