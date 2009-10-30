Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:53293 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbZJ3PKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 11:10:11 -0400
Received: by iwn10 with SMTP id 10so2182946iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 08:10:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890910291603h1b836cdx378a2a49d7421390@mail.gmail.com>
References: <43e72e890910291603h1b836cdx378a2a49d7421390@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 30 Oct 2009 08:09:56 -0700
Message-ID: <43e72e890910300809w310a2942m927991e4187841e4@mail.gmail.com>
Subject: Re: fyi - ath9k virtual wiphy - another thing we would need to synch
To: "Jouni.Malinen" <Jouni.Malinen@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 29, 2009 at 4:03 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> sc->sc_ah->opmode

Oh and where this is used we could probably just use the hw->conf->type

  Luis
