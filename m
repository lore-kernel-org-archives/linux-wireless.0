Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:50214 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbZJBUfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:35:05 -0400
Received: by iwn8 with SMTP id 8so799074iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2009 13:35:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 2 Oct 2009 13:34:49 -0700
Message-ID: <43e72e890910021334r7c838e9eyf684b7e533412f20@mail.gmail.com>
Subject: Re: 2.6.32-rc1-git2: Reported regressions from 2.6.31
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not bad we have only 2 for wireless, so far:

On Thu, Oct 1, 2009 at 12:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

iwl3945:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14299
> Subject         : oops in wireless, iwl3945 related?
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Date            : 2009-09-29 17:12 (3 days old)
> References      : http://marc.info/?l=linux-kernel&m=125424439725743&w=4

b43:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14277
> Subject         : Caught 8-bit read from freed memory in b43 driver at association
> Submitter       : Christian Casteyde <casteyde.christian@free.fr>
> Date            : 2009-09-30 18:06 (2 days old)

  Luis
