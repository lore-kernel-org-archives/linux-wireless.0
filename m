Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34938 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab3DQA7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 20:59:05 -0400
Received: by mail-pa0-f52.google.com with SMTP id fb10so627041pad.39
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 17:59:04 -0700 (PDT)
Date: Tue, 16 Apr 2013 17:58:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Neela Syam Kolli <megaraidlinux@lsi.com>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-scsi@vger.kernel.org,
	Jerry Chuang <jerry-chuang@realtek.com>,
	linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/28] proc: Add proc_mkdir_data() [RFC]
Message-ID: <20130417005855.GC11541@kroah.com> (sfid-20130417_025922_785734_FBE172FA)
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 16, 2013 at 07:26:30PM +0100, David Howells wrote:
> Add proc_mkdir_data() to allow procfs directories to be created that are
> annotated at the time of creation with private data rather than doing this
> post-creation.  This means no access is then required to the proc_dir_entry
> struct to set this.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> cc: Jerry Chuang <jerry-chuang@realtek.com>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> cc: linux-scsi@vger.kernel.org
> cc: devel@driverdev.osuosl.org
> cc: linux-wireless@vger.kernel.org
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
