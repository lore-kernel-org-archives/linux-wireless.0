Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44674 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1HKIsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 04:48:04 -0400
Received: by gya6 with SMTP id 6so1170704gya.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 01:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E43816D.6080005@candelatech.com>
References: <4E38DDB3.1030801@candelatech.com>
	<CA+yqC4YvAMLaao4dy2aXM7H5zPXySk4eAUZ2KSM4QnP+kQqF-A@mail.gmail.com>
	<4E39EB52.1090401@candelatech.com>
	<CA+yqC4a1xCPM4WN5U5Oth9PUqGSg+h6qZ4u2sV80h3zcEtzazg@mail.gmail.com>
	<4E43816D.6080005@candelatech.com>
Date: Thu, 11 Aug 2011 16:48:02 +0800
Message-ID: <CAJ-VmomygMyc-DxP7btY7yitiZ4Esw17goEo0BXcC8Bj_toqbQ@mail.gmail.com> (sfid-20110811_104808_920045_F1069BE4)
Subject: Re: Bridging wired to STA interfaces.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sam Leffler <sleffler@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 August 2011 15:14, Ben Greear <greearb@candelatech.com> wrote:

> I think I'll just force user to create an STA with matching MAC (for the
> MAC of the PC/whatever to be bridged).  Ath9k and ath5k can support at
> least 128 stations, so that will be plenty for our uses...
>
> We saw some problems changing MAC on STA after they were created, but
> it seems to be ok if we just create it with correct STA the first time,
> and we'll try to figure out why changing MAC was acting weird as well.

Oh wow, that's a cool use of multi-STA support. Now I want to get it
working in FreeBSD.

I think I may need to corner you sometime and sort out exactly how
this works. Nice thinking Ben!


Adrian
