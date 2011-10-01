Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1JARmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 13:42:20 -0400
Received: by wyg34 with SMTP id 34so1957868wyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 10:42:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Ug-wF+UMC3fLkrcb43x94_Pc0DeK51pDnVnDckiyshAQ@mail.gmail.com>
References: <CAB=NE6Ug-wF+UMC3fLkrcb43x94_Pc0DeK51pDnVnDckiyshAQ@mail.gmail.com>
Date: Sat, 1 Oct 2011 20:42:18 +0300
Message-ID: <CANUX_P0xz_uS8xb_rjF_=BR=fJ+QQDB74c-9YBQUwrn=ubdHaA@mail.gmail.com> (sfid-20111001_194223_140738_0CEBC75E)
Subject: Re: iwlagn rmmod BUG iwlagn_dev_cmd: Objects remaining on kmem_cache_close()
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 1, 2011 at 02:41, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
>
> While I rmmod iwlagn, I get this.
>
> mcgrof@tux ~ $ uname -r
> 3.1.0-rc5-wl+


Please check that you have this one:

Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun Sep 4 11:46:59 2011 +0300

    iwlagn: free the Tx cmd when a non empty Tx queue is freed


I can't find the commit ID right now
