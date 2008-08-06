Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:25508 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810AbYHFBMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 21:12:08 -0400
Received: by an-out-0708.google.com with SMTP id d40so466471and.103
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 18:12:07 -0700 (PDT)
Message-ID: <43e72e890808051812y1f6b18ecpac089e45d4c18b84@mail.gmail.com> (sfid-20080806_031215_600614_D6AEA3AF)
Date: Tue, 5 Aug 2008 18:12:07 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: CRDA and uevent
Cc: "linux kernel" <linux-kernel@vger.kernel.org>,
	"Marcel Holtmann" <marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At OLS we reviewed how CRDA [1] and its integration with the kernel
works. One comment was to have the kernel call a uevent instead of
calling call_usermodehelper() as this is a better accepted way of
calling user mode helpers and it provides a better framework. I still
am not sold on this but regardless I'd like to give it a shot. It
seems we would need to register a class for this.

Marcel I know you also mentioned about using device platform for this?
Is this correct or did I misunderstand? Can you elaborate a bit?

Thanks,

  Luis

[1] http://wireless.kernel.org/en/developers/Regulatory/CRDA
