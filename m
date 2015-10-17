Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33835 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbbJQJ7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 05:59:21 -0400
Received: by ykfy204 with SMTP id y204so105720220ykf.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 02:59:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB6w8env+MY_+nTr9ZEC3XQe24whCqx+ANp3UGndDruyYPRE6A@mail.gmail.com>
References: <CAB6w8env+MY_+nTr9ZEC3XQe24whCqx+ANp3UGndDruyYPRE6A@mail.gmail.com>
From: Ramprasad Vempati <ramprasad.vempati@gmail.com>
Date: Sat, 17 Oct 2015 15:29:01 +0530
Message-ID: <CAB6w8enBd9gwRYW=WQ4QwfUoipCvUxS7ZpbXOXq1tYxn0gAjKg@mail.gmail.com> (sfid-20151017_115925_086867_CB434478)
Subject: Re: How does tkip_mic_test work?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Can someone clarify?

Thanks,
Ram

On Fri, Oct 16, 2015 at 4:18 PM, Ramprasad Vempati
<ramprasad.vempati@gmail.com> wrote:
> Hi,
>
> I understand through mac80211/cfg80211 debugfs entry, we can write
> peer mac into file "tkip_mic_test" to send packet with wrong MIC.
>
> But I'm interested in how it works, as in most of cases, hardware is
> the one that typically encrypts and calculates MIC.  Does this entry
> ask underlying hardware to send packet with wrong MIC?  Or does it
> differently?
>
> Thanks,
> Ram
