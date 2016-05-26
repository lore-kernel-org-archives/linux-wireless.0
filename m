Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34658 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbcEZWHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 18:07:47 -0400
Received: by mail-oi0-f53.google.com with SMTP id b65so146444875oia.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2016 15:07:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACZXzRCRZH8SWUBdL8FaD915pT4S1rDb9Qnu1e8X75_0inu8mg@mail.gmail.com>
References: <CACZXzRCRZH8SWUBdL8FaD915pT4S1rDb9Qnu1e8X75_0inu8mg@mail.gmail.com>
Date: Fri, 27 May 2016 00:07:46 +0200
Message-ID: <CACna6rziPzLGnVVvZPQ26LeQY4nxeuXE_XNYPmH+ZOX7uyMWjg@mail.gmail.com> (sfid-20160527_000751_092690_F4B11EEA)
Subject: Re: [RFC] brcmfmac: Add tracepoints for bcmdhd-dissector tool
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Mikael Kanstrup <mikael.kanstrup@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 May 2016 at 12:59, Mikael Kanstrup <mikael.kanstrup@gmail.com> wrote:
> Add hexdump tracepoints to be used to dissect firmware
> protocol data with bcmdhd-dissector:
>   https://github.com/kanstrup/bcmdhd-dissector

I think it'd be worth describing it a bit more. What kind of tool is
it, is it something standardized, used at Broadcom or not? Even
README.md on github isn't very clear on that and I think commit should
be clear enough without checking external project homepage.
