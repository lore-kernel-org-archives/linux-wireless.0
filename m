Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64114 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbZIXTKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 15:10:17 -0400
Received: by fxm18 with SMTP id 18so1689885fxm.17
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 12:10:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku>
	 <20090924180251.14503.64152.stgit@tikku>
	 <43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
Date: Thu, 24 Sep 2009 12:10:19 -0700
Message-ID: <da94abde0909241210m69bd619sce62645c3aca9aae@mail.gmail.com>
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
	wiphy
From: Kalle Valo <kalle.valo@iki.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 11:35 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> So ath9k and ath5k keep their own strings for such things, to name the
> MAC/Baseband, and then the radio revision and subrevisions... What I'd
> like to see documented on the kdoc for hw_version is what exactly is
> expected to be put there.
>
> The hw_version and fw_version seem to be helpful in providing more
> information to userspace which you would not typically see -- things
> you would only tend to see on a dmesg output so at least for that
> purpose I think its nice. For example lspci won't really tell you the
> exact hardware type on atheros chipsets, so this seems nice.

Exactly, that's my idea here. And with this the information should be
easy to show in UI.

> Anyway, getting some more clarification on the docs would be nice.

I will definitely add documentation. I meant to send these patches RFC
for the implementation idea, but forgot to do it.

BTW, is there an easy way to get the module name for the interface?
That's also helpful information for the user.

Kalle
