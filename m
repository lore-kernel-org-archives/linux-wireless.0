Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43842 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaKZT6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 14:58:32 -0500
Received: by mail-lb0-f172.google.com with SMTP id u10so3083370lbd.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 11:58:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546E6C62.9010808@lwfinger.net>
References: <CAHg_5go+AZTytHq7OyoV_r35sj2wW0OwgBq+sm8R+zJbOXiYcA@mail.gmail.com>
 <546E6C62.9010808@lwfinger.net>
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Wed, 26 Nov 2014 20:58:10 +0100
Message-ID: <CAHg_5grY7m6FoyvnaavmzAVLNAso9KYM11dkR7fGhZ7dpnFJZg@mail.gmail.com> (sfid-20141126_205835_288309_0A970950)
Subject: Re: rtl8192ce 3.18 regression scan doesn't find any APs
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 11:34 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> I have reproduced the problem, but I do not yet know the fix. Please file a
> bug report at bugzilla.kernel.org on this problem. Be sure to mark it as a
> regression, and assign it to me. When I find the fix, being able to cite the
> bug report will help get a last-minute patch into 3.18.

Thanks for looking at this. Great that you could reproduce it.

I've filed https://bugzilla.kernel.org/show_bug.cgi?id=88951 and added
you to CC since I don't have permissions to change the Assigned to
field.
