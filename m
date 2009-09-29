Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64370 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZI2KpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 06:45:05 -0400
Received: by fxm18 with SMTP id 18so4346589fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 03:45:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909290859.25075.hs4233@mail.mn-solutions.de>
References: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com>
	 <200909290859.25075.hs4233@mail.mn-solutions.de>
Date: Tue, 29 Sep 2009 12:45:08 +0200
Message-ID: <1ba2fa240909290345k776826a6jc692d9d8dfe7577@mail.gmail.com>
Subject: Re: Firmware versioning best practices
From: Tomas Winkler <tomasw@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 8:59 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> Or shall we have the same firmware filename and simply query
>> the firmware for a map of capabilities? Any other ideas?
>
> Don't put the version into the filename. This is not a common
> practice for Linux / BSD / whatever systems. Usually you have
> a "kmail" file, not a kmail3.5, kmail4.0 and kmail4.2 file.

I think in this context libyyy.so.x.y.z is better analogy. firmware is
not an executable
What is the reasoning behind this common practice?

> Versions or capability maps can be stored inside the firmware and
> queried at load time. E.g. the libertas driver does it that way.

It's only check if it fits but cannot fall back to an older version.
.
>
> If you make your firmware redistributable (which I recommend),
> the version will also be stored in the package metadata, e.g.
> the rpm or deb file and the infrastructure for rpm/yum deb/apt.
>
> --
> http://www.holgerschurig.de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks
Tomas
