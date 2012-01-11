Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44161 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2AKBat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 20:30:49 -0500
Received: by vbbfc26 with SMTP id fc26so168463vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 17:30:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326237636.13074.389.camel@wwguy-huron>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
 <1324424765.13074.281.camel@wwguy-huron> <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
 <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
 <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
 <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
 <CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com>
 <CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
 <CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com>
 <CA+icZUUhg91UAPMRGgXYAvo6wkr5ogb+vW8SsB28BeUP_6-g6w@mail.gmail.com>
 <1324484074.13074.313.camel@wwguy-huron> <CAH5vBdJ4-33z3FbOwVG1QRzfFOwFpz1wccbQNDXEC6-NhBa31A@mail.gmail.com>
 <1324518057.4755.4.camel@wwguy-ubuntu> <CAH5vBdKwQ3vPr01PiRMmUqARK4CE44vM9WeVSx-QydpDLQtT1A@mail.gmail.com>
 <1326234428.13074.385.camel@wwguy-huron> <CAH5vBd++OmF11vBHYgNmLABm3pG3mOERcq5dgeP6o9fneRLODQ@mail.gmail.com>
 <1326237636.13074.389.camel@wwguy-huron>
From: Cheng Renquan <crquan@gmail.com>
Date: Tue, 10 Jan 2012 17:30:27 -0800
Message-ID: <CAH5vBdLjCsSdV+hzBMg2hpn+kh6a572FKmVs84cLCtR9XROKbg@mail.gmail.com> (sfid-20120111_023053_594887_4C6FA1A3)
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable when
 moving between multiple APs)
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 10, 2012 at 3:20 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi Cheng,

> Got it, very sorry for the problem you experience, yes, I agree with
> you, it might be because the noisy environment. Could you please send me
> the dmesg log with the following flags
>
> $sudo modprobe iwlwifi debug=0x1083
>
> Thanks
> Wey

Attached iwlwifi-debug-jan10.txt.xz privately to Guy since it may have
some privacy; please do not spread;

tried a few meeting rooms only the last one failed roaming; may be
because many ones have left office right now, don't have so much
noise; will try again another busy time;
