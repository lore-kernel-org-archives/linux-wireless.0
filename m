Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35123 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab0FQTYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 15:24:35 -0400
Received: by vws3 with SMTP id 3so70211vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 12:24:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C1A6E4F.6000708@cortland.com>
References: <4C1926E7.1070503@cortland.com>
	<AANLkTil-qhJ7fO3RNm4xwG1fA6uKeTkrD352ICU-z8Ab@mail.gmail.com>
	<4C1A6E4F.6000708@cortland.com>
Date: Thu, 17 Jun 2010 15:24:34 -0400
Message-ID: <AANLkTilD7x8a17kN2jxTX5pHwrrIGy0tUHTcWAdbfaBo@mail.gmail.com>
Subject: Re: OOPS in ath5k when setting coverage class
From: Bob Copeland <me@bobcopeland.com>
To: Steve Brown <sbrown@cortland.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 17, 2010 at 2:49 PM, Steve Brown <sbrown@cortland.com> wrote:
> I went a little further and tested the following patch.
>
> If it makes sense to you, I'll submit it.


Looks fine to me, but I do want to do a quick audit of the driver
to see if there are others.  We just fixed another one in setting
the antenna mode with the same root cause.

-- 
Bob Copeland %% www.bobcopeland.com
