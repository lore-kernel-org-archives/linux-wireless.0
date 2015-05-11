Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38388 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbbEKJO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 05:14:29 -0400
Received: by wiun10 with SMTP id n10so88537630wiu.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 02:14:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150511105204.112340biso205wvo@webmail.inescporto.pt>
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<20150511105204.112340biso205wvo@webmail.inescporto.pt>
Date: Mon, 11 May 2015 11:14:27 +0200
Message-ID: <CA+BoTQnpmFqyFnC+YTcGmm8z_n2JFuM9P8A-QtH9ET3e_iKXYQ@mail.gmail.com> (sfid-20150511_111435_859848_7A75E9F3)
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
From: Michal Kazior <michal.kazior@tieto.com>
To: =?UTF-8?B?TcOhcmlvIExvcGVz?= <mjlopes@inesctec.pt>
Cc: s prasad <sprasad.kandregula@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2015 at 10:52, Mário Lopes <mjlopes@inesctec.pt> wrote:
> Hello all.
>
> I have the same issue on OpenWRT, when using horst for sniffer mode, but
> different behaviour, reported here: https://dev.openwrt.org/ticket/15738

Firmware 999.999.0.636 has very poor monitor support and is known to
crash very often. It is advised to use 10.x firmware for
monitor/sniffing.


Michał
