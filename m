Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:48572 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754101AbYHPTWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2008 15:22:54 -0400
Message-ID: <48A728FF.7040306@overt.org> (sfid-20080816_212312_316157_D18DF7E1)
Date: Sat, 16 Aug 2008 12:22:39 -0700
From: Philip Langdale <philipl@overt.org>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <489A7CCF.1090407@overt.org> <20080807134530.GB17062@khazad-dum.debian.net> <48A06BBC.7060007@overt.org> <20080813092908.GA6806@khazad-dum.debian.net> <48A3D7A0.7010704@overt.org>
In-Reply-To: <48A3D7A0.7010704@overt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip Langdale wrote:
> 
> Now, when I release the kill switch, rfkill-input does indeed turn the
> radio on. Great. The remaining problem is that rfkill-input is setting
> it to soft-blocked when the switch is registered. I'm not sure why it's
> deciding to do that. Anyway, I'm almost there. Thanks.

Finally sorted it out. Updated diff is posted as v5.

--phil
