Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37448 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0LHRG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 12:06:26 -0500
Received: by vws16 with SMTP id 16so1201392vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 09:06:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101208165607.GE2423@tuxdriver.com>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
	<201012061714.15863.br1@einfach.org>
	<AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
	<AANLkTi=95mO085Y1PJ3brMMpHa=QvkxSB3SUpQysvKr+@mail.gmail.com>
	<20101208165607.GE2423@tuxdriver.com>
Date: Wed, 8 Dec 2010 12:06:25 -0500
Message-ID: <AANLkTikmZZuD1h45RkX3QE2xAQLfoZzwSecDXvojSw5=@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>,
	Jonathan Guerin <jonathan@guerin.id.au>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@venema.h4ckr.net>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 8, 2010 at 11:56 AM, John W. Linville
<linville@tuxdriver.com> wrote:
>> Found the patch:
>>
>> https://patchwork.kernel.org/patch/359722/
>
> Are you posting that for merging?  Or just for testing?

Testing -- I only compile tested it but it seemed relevant
to this thread.

-- 
Bob Copeland %% www.bobcopeland.com
