Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61297 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1JTLdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 07:33:52 -0400
Received: by qyk4 with SMTP id 4so5403253qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 04:33:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1319109568.26974.YahooMailNeo@web161206.mail.bf1.yahoo.com>
References: <1319109568.26974.YahooMailNeo@web161206.mail.bf1.yahoo.com>
Date: Thu, 20 Oct 2011 13:33:51 +0200
Message-ID: <CA+icZUXyYSVUA-PTCQB7z167iLAnh83DEJxOGoYB4qxaFkTZog@mail.gmail.com> (sfid-20111020_133356_268861_DD84447B)
Subject: Re: ath5k: controlling powersave with iw or iwconfig fails
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-users@lists.ath5k.org" <ath5k-users@lists.ath5k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Which iw version?

- Sedat -

On Thu, Oct 20, 2011 at 1:19 PM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
> Hello all,
> trying to disable PS on ath5k (Linux 3.0) gives:
>
> iw dev wlan0 set power_save off
> command failed: Operation not supported (-95)
>
>
> Is there any special magic required to disable power saving?
> It seems to interfere with our amplifier...
>
>
> --
> Regards
> Joerg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
