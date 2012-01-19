Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48508 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2ASWex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 17:34:53 -0500
Received: by iagf6 with SMTP id f6so512919iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2012 14:34:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC9WiBh5-vS6UmCYCs911WAudmWDtsgDPmHim71LtvaC81HsWQ@mail.gmail.com>
References: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
 <CAC9WiBh5-vS6UmCYCs911WAudmWDtsgDPmHim71LtvaC81HsWQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 20 Jan 2012 09:34:30 +1100
Message-ID: <CAGRGNgWNKj6fQSqGen8+AffvygjEb2AzEh9VWdKgK2oR6F2WUQ@mail.gmail.com> (sfid-20120119_233456_941363_36ACAD7F)
Subject: Re: brcmsmac broken with 3.2
To: Francis Moreau <francis.moro@gmail.com>
Cc: alwin@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Francis,

On Fri, Jan 20, 2012 at 08:19, Francis Moreau <francis.moro@gmail.com> wrote:
> Hi all,
>
> I'm wondering now why the brmsmac driver had been removed from the
> staging driver tree if no one cares.

People do care, it's just that time is limited, and people are busy.

Whilst nobody has provided this advice, the usual "My device doesn't
work and I'm not using the latest version of the driver" / "My device
doesn't work and I'm using my own patches" advice is to use the
bleeding edge Compat Wireless, without any extra patches, and see if
the problem can be reproduced with that.

See here:

http://linuxwireless.org/en/users/Download

Compat Wireless is the current wireless stack re-packaged to be
compilable on older kernels. Give it a shot, tell us if it works.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
