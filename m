Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:40342 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3J3Nei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 09:34:38 -0400
Received: by mail-we0-f172.google.com with SMTP id q58so1318413wes.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 06:34:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131030083432.GA1478@redhat.com>
References: <20131025103751.GB16384@redhat.com> <1382699879.12755.0.camel@jlt4.sipsolutions.net>
 <20131030083432.GA1478@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Wed, 30 Oct 2013 13:34:17 +0000
Message-ID: <CAJZjf_wMdQm9SYPm8AKv9us1APYS3C7E6TJeFu=v3fPmWGTh_g@mail.gmail.com> (sfid-20131030_143441_637164_582187C9)
Subject: Re: [PATCH] iwl3945: do not print RFKILL message
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 30, 2013 at 8:34 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Dietmar or Pedro, could you test attached patch (my old laptop with 3945
> does not work any longer). It is alternative to previous patch posted
> before, does rfkill work ok with it?

My main laptop is no longer the one with the 3945. That being said, I
still intend to test the other patches (powersave) and I can add this
one to the mix, I just don't know when :)

-- 
Pedro
