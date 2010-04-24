Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48898 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab0DXN7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Apr 2010 09:59:09 -0400
Received: by pvg4 with SMTP id 4so193692pvg.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Apr 2010 06:59:08 -0700 (PDT)
Message-ID: <4BD2F929.7030600@lwfinger.net>
Date: Sat, 24 Apr 2010 08:59:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: RTL 8187b - naughty behaviour
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>	 <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>	 <4BB773A9.2070703@lwfinger.net>	 <n2n917a57cb1004031000h9910230ew50c6380788a64b1c@mail.gmail.com>	 <q2k917a57cb1004100507s17249540xfb11a2e2f0a2dd76@mail.gmail.com>	 <w2i69e28c911004101150h9db59aa1x2f9d12964f3c3fc1@mail.gmail.com>	 <y2g917a57cb1004101240g8033e225n57bf68b6d37b5431@mail.gmail.com>	 <q2k69e28c911004110635nac8100f6pe014361ed0a516a5@mail.gmail.com>	 <u2k917a57cb1004221345i19eb6354yffdc302f6a9b74c6@mail.gmail.com>	 <k2s69e28c911004231316u7fd3118qe971919ed8a433d7@mail.gmail.com> <l2z917a57cb1004240347jcd95308bp5be3b66c8638907d@mail.gmail.com>
In-Reply-To: <l2z917a57cb1004240347jcd95308bp5be3b66c8638907d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2010 05:47 AM, Rogerio Luz Coelho wrote:
> Will check this ... but it seems to be a module ...If I have rtl8187
> and rtl8187b in the blacklist will I be able to load them manually?

Yes, you will be able to load manually. BTW, there is no rtl8187b. Both
the RTL8187L and the RTL8187B (device names) use driver rtl8187.

In future discussions, please trim the replies. We do not need to see
the same stuff over and over.

Larry

