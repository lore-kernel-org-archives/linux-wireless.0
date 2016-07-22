Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36894 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbcGVQYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 12:24:55 -0400
Received: by mail-wm0-f46.google.com with SMTP id i5so73523760wmg.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jul 2016 09:24:54 -0700 (PDT)
From: Christopher Williamson <home@chrisaw.com>
In-Reply-To: <1469204186.15064.6.camel@redhat.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
 <1468946312.5661.2.camel@redhat.com> <CANXHH3kKV4m6rw9O=6x_QT2vwr7Tnx9EddpFq1VXfhnVdg9pFg@mail.gmail.com>
 <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
 <CANXHH3k3wSYYc2xS1rk9JqeWmekC+79YCYshMcXA-yz4rX_+Hw@mail.gmail.com>
 <1469033825.3004.8.camel@redhat.com> <1469033825.3004.8.camel@redhat.com>
 <CANXHH3minohF3z9bWc2NAghiU=w4DbsH1jU8iE8=v7H1pGdFcg@mail.gmail.com>
 <1469051432.3286.4.camel@redhat.com> <1469051432.3286.4.camel@redhat.com>
 <CANXHH3n0=dmV+2D9FeOoGuqDvKJHdpnOMdYH1Ecr3TACJ5FXYQ@mail.gmail.com>
 <1469115440.29944.1.camel@redhat.com> <CANXHH3kHFDkRUTMyOheFwpJasqOmtGrQ3dG7LP_L0CBN87Aagw@mail.gmail.com>
 <CANXHH3kwH_A-45D9ZsT3Afz3LxYW6Pgz06qBzfnK+jtcg8FiNg@mail.gmail.com>
 <1469133499.18298.8.camel@redhat.com> <1469133499.18298.8.camel@redhat.com>
 <etPan.579137d1.40bb3278.381a@chrisaw.com> <CANXHH3=852nV-4rjt8bO47Mbt02JNHNFGzytk3kiV1RQ39rLwg@mail.gmail.com>
 <435adbc6-9fa3-e9e3-9815-8cf4b62e5342@broadcom.com> <CANXHH3mn2U5X5n9OB6+uESDgeRt6r6WyGV5wT0=MQwvuvD870g@mail.gmail.com>
 <CANXHH3mn2U5X5n9OB6+uESDgeRt6r6WyGV5wT0=MQwvuvD870g@mail.gmail.com>
 <CANXHH3mOsN3-U=BS4fA6iax0ciwbSSywHAgOhHCNj8e7CPCyfQ@mail.gmail.com>
 <1469204186.15064.6.camel@redhat.com> <1469204186.15064.6.camel@redhat.com>
MIME-Version: 1.0
Date: Fri, 22 Jul 2016 12:24:52 -0400
Message-ID: <CANXHH3nvu7TC=x5RTR_WcgGkd2=_0h4BZrc_Nv74023nrc3P5w@mail.gmail.com> (sfid-20160722_182459_751058_997AABD8)
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

I will check out the WPA2 vs WPA vs open wireless thing in a few mins.

For now though - the iwlist scan results for both a USB device and the
libertas device:

USB: http://termbin.com/hdwl
Libertas: http://termbin.com/jxh7

Will follow up shortly with WPA and Open network configs.

Christopher Williamson



On 22 July 2016 at 17:16:29, Dan Williams
(dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:

> Hi Dan,
>
> I will check out the WPA2 vs WPA vs open wireless thing in a few mins.
>
> For now though - the iwlist scan results for both a USB device and the
> libertas device:
>
> USB: http://termbin.com/hdwl
> Libertas: http://termbin.com/jxh7
>
> Will follow up shortly with WPA and Open network configs.
>
> *Christopher Williamson*
