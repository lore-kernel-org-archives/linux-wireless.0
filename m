Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49558 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2GQPF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 11:05:58 -0400
Received: by gglu4 with SMTP id u4so465425ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 08:05:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2TiaDDhC6q1kCjjh4rxxgeiDoDET93xZ6jxziA-mSRLA@mail.gmail.com>
References: <CANugF35YQzs7gi4htrgCUKrTDp_ia0RUo9g_HNJ=CzfnOCkO2g@mail.gmail.com>
 <CANugF37dDx1mvNJ-Y3is6OaeVFD1KwH=yh8Xef2BrN=YQPsiZQ@mail.gmail.com>
 <1341558944.4462.9.camel@jlt3.sipsolutions.net> <CANugF35qjKLdhBprQviNJaAPfM910wFCSbyEvdcCRj_UoKLqPQ@mail.gmail.com>
 <CANugF34NThUR1KkDHX8tiO7RC8uJLfbGLU=0=fFd2OQcBnAwAw@mail.gmail.com>
 <CAD2nsn1xxNBnBB6S-6e3+-exW=NZhgsDiyuQQmFM8Om4U1pnAg@mail.gmail.com>
 <CANugF35nYYToPfPm7pg_bQhBgwdSwusbkTokDhVxZkB+Xggvvw@mail.gmail.com> <CAD2nsn2TiaDDhC6q1kCjjh4rxxgeiDoDET93xZ6jxziA-mSRLA@mail.gmail.com>
From: Andrew Chant <andrew.chant@gmail.com>
Date: Tue, 17 Jul 2012 08:05:16 -0700
Message-ID: <CANugF36mAhepfpNjW4htfe3DKCtUdCX5T-V2Auv-JAmoj4zA_w@mail.gmail.com> (sfid-20120717_170601_593782_D1884C9B)
Subject: Re: v3.4.4 ath9k: kernel NULL pointer dereference in skb_dequeue
 during heavy udp xmit
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was good overnight.  Is this worth trying to put into 3.4.6 if there is one?

On Mon, Jul 16, 2012 at 8:18 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> Hi Andrew,
>
> On Tue, Jul 17, 2012 at 8:36 AM, Andrew Chant <andrew.chant@gmail.com> wrote:
>> Thanks.  That patch seems good against 3.4.4 after the first few
>> minutes - I'll leave it to run overnight.
>
> thanks, sure!
>
> --
> thanks,
> shafi
