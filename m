Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f165.google.com ([209.85.217.165]:59636 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbZCPW53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 18:57:29 -0400
Received: by gxk9 with SMTP id 9so2331082gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 15:57:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BED464.2010904@erley.org>
References: <49BED464.2010904@erley.org>
Date: Mon, 16 Mar 2009 15:57:26 -0700
Message-ID: <45e8e6c40903161557u18133705q9e0c036c8f5367b1@mail.gmail.com> (sfid-20090316_235738_983887_C05EF76B)
Subject: Re: [rfc] Implement ath9k mesh point operation
From: Andrey Yurovsky <andrey@cozybit.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pat,

On Mon, Mar 16, 2009 at 3:36 PM, Pat Erley <pat-lkml@erley.org> wrote:
> Currently, you need to trigger a scan on the mesh point interface to
> enable beaconing. =A0This is the same behavior the ath5k, rt2500usb a=
nd
> rt61pci drivers exhibit. =A0Is this a mac80211 design flaw, or someth=
ing
> in all of these drivers?

Are you really seeing this behavior on ath5k?  I have never seen that
happen, if it's new then it's a regression.  rt2x00 does have this
problem at this time.

  -Andrey
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
