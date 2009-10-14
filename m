Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:35333 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbZJNR5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 13:57:30 -0400
Received: by iwn10 with SMTP id 10so19798iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 10:56:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <122696.42074.qm@web55302.mail.re4.yahoo.com>
References: <43e72e890910140749y43583f8av4c2885c3f22ac987@mail.gmail.com>
	<122696.42074.qm@web55302.mail.re4.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 14 Oct 2009 10:56:33 -0700
Message-ID: <43e72e890910141056x6c087435vda2381936ba7ddde@mail.gmail.com>
Subject: Re: Wifi Alliance announces peer-to-peer specification is in the
	works
To: austinxxh-linux@yahoo.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2009 at 10:14 AM, X Xiao <austinxxh-linux@yahoo.com> wrote:
> isn't this just encouraging vendors to provide universal ibss/adhoc support in the software?

No, its more like making AP mode of operation ubiquitous. Letting you
simultaneously start AP mode while keeping your other existing
connection alive and sometimes even on different channels. See ath9k
virtual wiphy implementation [1] as a simple example using legacy
modes of operation (no peer-to-peer stuff yet included). Obviously
there is a lot more to this though but since the specification is not
yet released more details cannot be provided yet.

[1] http://wireless.kernel.org/en/users/Drivers/ath9k/debug#wiphy

  Luis
