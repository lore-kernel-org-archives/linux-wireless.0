Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53196 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3GPLDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 07:03:20 -0400
Received: by mail-qc0-f178.google.com with SMTP id c11so274545qcv.9
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 04:03:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130716102743.GA8321@redhat.com>
References: <20130107110759.GC6931@redhat.com> <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com> <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com> <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com> <20130625142514.GA1938@redhat.com>
 <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com> <20130716102743.GA8321@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 16 Jul 2013 12:02:59 +0100
Message-ID: <CAJZjf_w-uyANcBx_iYgToVCSUvh=HSRevADg-3VOVoPcNA0F6Q@mail.gmail.com> (sfid-20130716_130323_318118_FBE2F448)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 16, 2013 at 11:27 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> You can provide me logs with disable_hw_scan=0, if you manage to
> trigger a Microcode error.

I can't trigger the microcode error with the debug. The firmware
however gets corrupted and reloading the module does not fix it
(firmware validation fails until I restart) -- curiously after a
'power info' RXON (? or similar, can't access the logs now) is sent to
the card.

I'll test again tomorrow.
