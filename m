Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34158 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbbEQIrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 04:47:53 -0400
Received: by igblo3 with SMTP id lo3so66067645igb.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2015 01:47:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com>
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>
	<5557556C.2080107@lwfinger.net>
	<CACna6rwCapwThrMGt2HV_YyPQtZ+xRPJdBcapRqs2mkvGPdmSQ@mail.gmail.com>
	<5557B396.9080300@gmail.com>
	<CA+0W_At43pB=FeBR4jJzKxO3ruaATAidU8rimBOE3bLM1wKGsA@mail.gmail.com>
Date: Sun, 17 May 2015 10:47:52 +0200
Message-ID: <CACna6rzxZJg3MHsBV3vtaEtgUbh9umE6CS=2YkgkexT51J1oiw@mail.gmail.com> (sfid-20150517_104756_894946_2685C519)
Subject: Re: lspci not working
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Schmirr Wurst <schmirrwurst@gmail.com>
Cc: Arend van Spriel <aspriel@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 May 2015 at 02:21, Schmirr Wurst <schmirrwurst@gmail.com> wrote:
> I tried as suggested to had a look at
> /sys/bus/sdio/devices, but the only devices around there a 3
> mmc1:0001:1 to :3, I guess it is something else...

Why do you guess so? You didn't provide us any details about entries there.


> In that directory, I see a directory mmc1:0001:2
> under device I have 0xa94d
>
> I completly lost, maybe you understand that information, sorry..

You provided only one single device id, without even vendor id. Give
us at least a list of devices, e.g. by their modalias, like
cat /sys/bus/sdio/devices/*/modalias
