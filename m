Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:14756 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbYHEXv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 19:51:58 -0400
Received: by an-out-0708.google.com with SMTP id d40so461731and.103
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 16:51:57 -0700 (PDT)
Message-ID: <43e72e890808051651t6a85d20g9ce12f23de206690@mail.gmail.com> (sfid-20080806_015202_100969_C7B806FB)
Date: Tue, 5 Aug 2008 16:51:57 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Gabriel de Perthuis" <Gabriel.de-Perthuis@laposte.net>
Subject: Re: [PATCH] Fix incorrect conditional nesting, that prevented inclusion of compat symbols.
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217959540-9612-1-git-send-email-Gabriel.de-Perthuis@laPoste.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1217959540-9612-1-git-send-email-Gabriel.de-Perthuis@laPoste.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 5, 2008 at 11:05 AM, Gabriel de Perthuis
<Gabriel.de-Perthuis@laposte.net> wrote:
> Kernels 2.6.23 or above didn't get these symbols:
> device_create_vargs
> device_create_drvdata
> register_rfkill_notifier
> unregister_rfkill_notifier
> rfkill_force_state
>
> Also fix a related comment typo found checking compat/compat.h .

Thanks, patch applied, and new compat tarball generated. Please keep
in mind I've frozen compat-wireless from updates from wireless-testing
as new TX MQ changes have not yet been backported so all we get was
this compat update in the new tarball. At some point if we don't get
TX MQ changes backported we may consider just freezing mac80211 for it
and taking in only bug fixes and new drivers.

  Luis
