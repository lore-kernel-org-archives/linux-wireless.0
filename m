Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:46030 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764387AbZDBPFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 11:05:36 -0400
Received: by gxk4 with SMTP id 4so1303546gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 02 Apr 2009 08:05:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D4C7B3.7010803@gmail.com>
References: <49D4C7B3.7010803@gmail.com>
Date: Thu, 2 Apr 2009 11:05:33 -0400
Message-ID: <b6c5339f0904020805w5e210c2bl542eadb20ac5d6c7@mail.gmail.com> (sfid-20090402_170542_949524_0601287B)
Subject: Re: Trouble Associating with ath5k on AR5212
From: Bob Copeland <me@bobcopeland.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 2, 2009 at 10:12 AM, Will Keaney <keaneyw@gmail.com> wrote:
> Hello,
> I have been following the wireless-testing branch for a few months,
> hoping with each revision that my Atheros card would finally work
> properly with ath5k. =A0So far, I've been able to scan for and see ne=
arby
> networks, but I haven't been able to associate to them.

Does limiting wpa_supplicant to only scan the 2 GHz channels help?

e.g. setting "scan_freq=3D2412 2437 2462" in your wpa_supplicant.conf
scans 1 6 and 11.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
