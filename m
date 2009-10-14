Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:33257 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZJNGCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 02:02:39 -0400
Received: by ewy4 with SMTP id 4so4115546ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 23:02:02 -0700 (PDT)
From: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
To: tim.gardner@canonical.com
Subject: Re: Stable compat-wireless 2.6.32-rc4 released
Date: Wed, 14 Oct 2009 11:31:47 +0530
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com> <4AD51A7C.9060207@canonical.com> <43e72e890910131750s4d2cdb20o76d721087d9b3aaf@mail.gmail.com>
In-Reply-To: <43e72e890910131750s4d2cdb20o76d721087d9b3aaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910141131.47500.kunal.gangakhedkar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 Oct 2009 6:20:33 am Luis R. Rodriguez wrote:
> On Tue, Oct 13, 2009 at 5:25 PM, Tim Gardner <tim.gardner@canonical.com> 
wrote:
> > Speaking as a distro, what advantage does the stable wireless backport
> > offer for the currently released kernel if we are already consumers of
> > stable updates?
>
> Well if you are a distro stuck on the 2.6.31 kernel the stable
> compat-wireless-2.6.32 gets you 2.6.32 wireless bits on 2.6.31 and
> that means any features/drivers/large fixes/enhancements that didn't
> make it to 2.6.31.
>

Isn't this the whole purpose of linux-backports-modules in ubuntu as well?

Kunal
