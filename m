Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50560 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2JFU17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 16:27:59 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so6548187iea.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2012 13:27:58 -0700 (PDT)
Message-ID: <5070944B.4010205@lwfinger.net> (sfid-20121006_222802_091030_C6B502DB)
Date: Sat, 06 Oct 2012 15:27:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rami Rosen <roszenrami@gmail.com>
CC: =?ISO-8859-1?Q?=22Mikko_V=2E_Viinam=E4ki=22?=
	<Mikko.Viinamaki@students.turkuamk.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
Subject: Re: OpenFWWF for b43
References: <0C7D424D957547489E16A29D0D15433494C29E7FE8@AMKMS11.ad.turkuamk.fi> <CAKoUArnsntysudq3CRric4gb3eUOLq2f9ppkUGxbqWhSZp7yhg@mail.gmail.com>
In-Reply-To: <CAKoUArnsntysudq3CRric4gb3eUOLq2f9ppkUGxbqWhSZp7yhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2012 02:15 PM, Rami Rosen wrote:
> Hi,
> - Thanks ! good news !
>
> The link to b43-tools seems to be broken.
>
> This failed:
> git clone http://git.bu3sch.de/git/b43-tools.git
>
> The b43_v4.6.tar.gz can be downloaded
> (BTW, when running tar xfz  b43_v4.6.tar.gz,
> am empty  file named b43_v4.6.tar.gz is created inside
> b43_v4.6/ folder)

That repo was converted from HTTP to GIT form some time ago. The correct request is

git clone git://git.bu3sch.de/git/b43-tools.git

It appears, however, the git.bu3sch.de is down.

Larry


