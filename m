Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62404 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab2EITBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 15:01:31 -0400
Received: by eaaq12 with SMTP id q12so248614eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 12:01:30 -0700 (PDT)
References: <1336361682-2771-1-git-send-email-zero.lin.0203@gmail.com> <CAL1gcdMBj_w5qbMX=kxcW6yow7UgSfSrWjz6TrKkFZiJCtS1cg@mail.gmail.com> <599E416D1C5C994980C45977191D726906AB2FE230@MTKMBS03.mediatek.inc> <20120509183304.409ace0e@destiny.ordissimo>
In-Reply-To: <20120509183304.409ace0e@destiny.ordissimo>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Message-Id: <424677BB-489B-4F60-B64E-9F5FE432B27E@gmail.com> (sfid-20120509_210134_938337_639BDDCE)
Cc: =?utf-8?Q? "Zero_Lin_=28=E6=9E=97=E7=91=9E=E9=9D=92=29" ?=
	<zero.lin@mediatek.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH] rt2x00:Add RT539B chipset support V2
Date: Wed, 9 May 2012 21:01:24 +0200
To: Anisse Astier <anisse@astier.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 mei 2012, at 18:33, Anisse Astier <anisse@astier.eu> wrote:

> On Mon, 7 May 2012 21:18:50 +0800, Zero Lin (林瑞青) <zero.lin@mediatek.com> wrote :
> 
>> Dear Gertjan,
>> 
>> I am sorry, what should I do now?
>> Re-send a patch?
> 
> I think what Gertjan meant is that you should resend the first version of
> you patch with the 0x539b in the correct position.
> 
> The problem with the V2 of your patch was that it was on top of your first
> version, therefore not usable separately.

That is exactly what I meant.

And sorry for not responding earlier. I'm just very busy at the moment with very little time for my linux related hobby :-(


>> 
>> BR,
>> Zero
>> 
>> -----Original Message-----
>> From: Gertjan van Wingerde [mailto:gwingerde@gmail.com] 
>> Sent: Monday, May 07, 2012 8:40 PM
>> To: Zero Lin
>> Cc: users@rt2x00.serialmonkey.com; linux-wireless@vger.kernel.org; John Linville; Zero Lin (林瑞青)
>> Subject: Re: [PATCH] rt2x00:Add RT539B chipset support V2
>> 
>> Hi,
>> 
>> On Mon, May 7, 2012 at 5:34 AM, Zero Lin <zero.lin.0203@gmail.com> wrote:
>>> From: "Zero.Lin" <Zero.Lin@mediatek.com>
>>> 
>>> Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>  
>> 
>> I'm sorry, but you will have to do this as a complete new patch replacing your old one, not as an incremental to your initial patch.
> 
> Regards,
> 
> Anisse
