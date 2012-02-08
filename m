Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37820 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756522Ab2BHBUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 20:20:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VS79S4R6wQddQCqPfoYPyRbPzSdAYN2Mxfi-4G_sfCvg@mail.gmail.com>
References: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
 <20120206160727.GA21048@tuxdriver.com> <20120207041958.GA32377@bombadil.infradead.org>
 <CAB=NE6VS79S4R6wQddQCqPfoYPyRbPzSdAYN2Mxfi-4G_sfCvg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 7 Feb 2012 17:19:52 -0800
Message-ID: <CAB=NE6Wv3PEJj5zKfK2o869ntxuU3V+Nv2dgKX1eDtk3zQ04dA@mail.gmail.com> (sfid-20120208_022033_111397_65BA2B7B)
Subject: Re: [PATCH] compat: add compat kernel checker and downloader
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Andy Whitcroft <apw@canonical.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, hauke@hauke-m.de,
	kernel-team@lists.ubuntu.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 8:56 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> Come to think of it.. we could bastardize Ubuntu's PPA packages for
> mainline kernels, translate the deb packages into tar files and some
> sort of grub-update or whatever scrip to run in the end? That still
> seems like a lot of work.
>
> The current option allows us to use either distro kernels or whatever
> you have installed.. not sure how else to improve this. Didn't we have
> some sort of distro agnostic package crap? Maybe?

Or -- Andy -- any chance we can get some of the deb contents unpacked
into a distro-agostic tarball of some sort that we can use ? I ask
given that you guys already host the sources and all that.

  Luis
