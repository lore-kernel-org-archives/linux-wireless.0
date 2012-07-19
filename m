Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61597 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2GSKoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 06:44:15 -0400
Received: by vcbfk26 with SMTP id fk26so1836371vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 03:44:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120719133452.2fb375ae@emcraft.com>
References: <20120719133452.2fb375ae@emcraft.com>
Date: Thu, 19 Jul 2012 12:44:14 +0200
Message-ID: <CAOZOX0V=npQuQ03kur0mo7PtkdGVYiFO5B3OKhB7CMibLk50Ew@mail.gmail.com> (sfid-20120719_124418_699186_C116EDF2)
Subject: Re: Access Point Mode for Ralink RT5370?
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Sergei Poselenov <sposelenov@emcraft.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jul 19, 2012 at 11:34 AM, Sergei Poselenov
<sposelenov@emcraft.com> wrote:
> Hello,
>
> Does compat-wireless support the Access Point mode for the Ralink
> RT5370 chip? The driver source pack from the Ralink site only supports
> Managed and Ad-Hoc modes.

Yes, the rt2x00-based drivers as found in the compat-wireless package
are working in AP mode.

Ivo
